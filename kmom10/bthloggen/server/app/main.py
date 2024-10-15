#!/usr/bin/env python3

#
# Main module for running FastAPI server for 'bthloggen'
#

from typing import Union
from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def get_doc():
    return {
        "/": "Supported paths",
        "/data": "Show all entries",
        "/data?ip=<ip>": "Show entries with matching ip-adress",
        "/data?url=<url>": "Show entries with matching url",
        "/data?month=<month>": "Show entries with matching month",
        "/data?day=<day>": "Show entries with matching day",
        "/data?time=<time>": "Show entries with matching time",
        "/data?ip=<ip>&url=<url>&month=<month>&day=<day>&time=<time>": "Show entries with any combination of matches",
    }


@app.get("/data")
def get_data(
    ip: Union[str, None] = None,
    url: Union[str, None] = None,
    month: Union[str, None] = None,
    day: Union[str, None] = None,
    time: Union[str, None] = None,
):
    res = {
        "ip": ip,
        "url": url,
        "month": month,
        "day": day,
        "time": time
    }

    return res
