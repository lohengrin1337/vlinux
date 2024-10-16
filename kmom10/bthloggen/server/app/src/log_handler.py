#!/usr/bin/env python3

"""
Module for LogHandler class
"""

import json
from pathlib import Path

class LogHandler():
    """ Access json-logfile, and filter results """

    def __init__(self, file = "/server/app/data/log.json"):
        """ Set and verify file path """
        path = Path(file)
        if not path.exists():
            raise FileNotFoundError(f"File not found: '{file}'")

        self._file_path = path
        self._log = []



    async def fetch_log(self):
        """ Fetch_log and parse json-log to self._log
            List of dicts [{'ip': '11.11.1111', 'day': ...}, {}...] """
        with open(self._file_path, "r") as file:
            self._log = json.load(file)
            print("*** LOG WAS FETCHED ***")



    async def all_entries(self):
        """ Get all entries (list of dicts) """
        if not self._log:
            await self.fetch_log()

        # print count to server log
        count = len(self._log)
        print(f"all entries: {count}")

        return self._log



    async def filter_entries(self, filters: dict = {}):
        """ Filter the entries by optional filters, and return result (list of dicts) """
        result = await self.all_entries()

        for f_key, f_val in filters.items():
            if f_val:
                f_val_lower = f_val.lower()
                result = list(filter(lambda entry: self.filter_by(entry, f_key, f_val_lower), result))

                # print count to server log
                count = len(result)
                print(f"{f_key}: {count}")

        return result



    def filter_by(self, entry: dict, f_key: str, f_val: str):
        """ Filter entries by specified value (case-insensitive) """
        match f_key:
            case "ip" | "url":
                return self.val_in_data(f_val, entry[f_key])
            case "month" | "day":
                return self.val_is_data(f_val, entry[f_key])
            case "time":
                return self.val_in_time(f_val, entry[f_key])



    def val_in_data(self, value: str, data: str):
        """ check if data (ip/url) has value in it (case-insensitive) """
        return value in data



    def val_is_data(self, value: str, data: str):
        """ check if value matches data (month/day) (case-insensitive) """
        return value == data



    def val_in_time(self, value: str, time: str):
        """ Check if value (time query) matches time (time of entry)
            one unit at a time
            hours, minutes, seconds """
        # log entry (time: '12:13:14' -> ['12', '13', '14'])
        time_list = time.split(":")
        time_length = len(time_list)

        # time query (time= '12' -> ['12'] or '12:13:14' -> ['12', '13', '14'])
        value_list = value.split(":")
        value_length = len(value_list)

        flag = True
        i = 0

        # iterate until a query unit is not matching, or
        #         until the value_list is done, or
        #         until the time_list is done
        while flag and value_length > i and time_length > i:
            flag = True if value_list[i] == time_list[i] else False
            i += 1

        return flag
