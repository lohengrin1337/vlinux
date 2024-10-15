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
        self._log = {}

    async def fetch_log(self):
        """ Fetch and parse json-log to self._log (dict) """
        print("fetching log")
        with open(self._file_path, "r") as file:
            self._log = json.load(file)
    
    async def get_log(self):
        """ Get log as dict """
        if not self._log:
            await self.fetch_log()
        return self._log
