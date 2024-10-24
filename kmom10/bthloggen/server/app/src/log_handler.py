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



    async def get_entries(self, filters: dict = {}):
        """ Filter the entries by optional filters, and return result (list of dicts) """
        await self._fetch_log()

        # print count to server log (all entries)
        count = len(self._log)
        print(f"*** 'no filter':\t {count} entries")

        for f_key, f_val in filters.items():
            if f_val:
                f_val_lower = f_val.lower()
                self._log = list(filter(lambda entry: self._filter_by(entry, f_key, f_val_lower), self._log))

                # print count to server log (after each filter)
                count = len(self._log)
                print(f"*** '{f_key} {f_val}':\t {count} entries")

        return self._log



    async def _fetch_log(self):
        """ Fetch_log and parse json-log to self._log
            List of dicts [{'ip': '11.11.1111', 'day': ...}, {}...] """
        with open(self._file_path, "r") as file:
            self._log = json.load(file)



    def _filter_by(self, entry: dict, f_key: str, f_val: str):
        """ Filter entries by specified value (case-insensitive) """
        match f_key:
            case "ip" | "url":
                return self._val_in_data(f_val, entry[f_key])
            case "month" | "day":
                return self._val_is_data(f_val, entry[f_key])
            case "time":
                return self._data_starts_with_val(f_val, entry[f_key])



    def _val_in_data(self, value: str, data: str):
        """ check if data has value in it (ip/url, case-insensitive) """
        return value in data



    def _val_is_data(self, value: str, data: str):
        """ check if value matches data (month/day, case-insensitive) """
        return value == data



    def _data_starts_with_val(self, value: str, data: str):
        """ Check if data starts with value (time) """
        return data.startswith(value)
