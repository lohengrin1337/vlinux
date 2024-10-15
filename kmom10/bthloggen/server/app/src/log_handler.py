#!/usr/bin/env python3

"""
Module for LogHandler class
"""

import json
from pathlib import Path


class LogHandler():
    """ Access json-logfile, and filter results """

    def __init__(self, file = "/server/app/data/log.json"):
        path = Path(file)
        if not path.exists():
            raise FileNotFoundError(f"File not found: '{file}'")

        self._file_path = path
        self._log = []

    async def fetch_log(self):
        """ Fetch_log and parse json-log to self._log (dict) """
        print("fetch_loging log")
        with open(self._file_path, "r") as file:
            # parse to list of dicts [{'ip': '11.11.1111, 'day': ...}, {}...']
            self._log = json.load(file)
    
    async def all_entries(self):
        """ Get all entries (list of dicts) """
        if not self._log:
            await self.fetch_log()

        # print(f"log: {self._log}")

        return self._log

    async def filter_entries(self, filters: dict = {}):
        """ Filter the entries by optional filters, and return result (list of dicts) """
        result = await self.all_entries()

        for f_key, f_val in filters.items():
            if f_val:
                f_val_lower = f_val.lower()
                result = list(filter(lambda entry: self.filter_by(entry, f_key, f_val_lower), result))

        return result

    def filter_by(self, entry: dict, f_key: str, f_val: str):
        """ Filter entries by specified value (case-insensitive) """
        return f_val in entry[f_key].lower()
