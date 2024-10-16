#!/usr/bin/env python3

#
# Main module for running FastAPI server for 'bthloggen'
#

from typing import Union
from fastapi import FastAPI
from src.log_handler import LogHandler

app = FastAPI()



@app.get("/")
def get_doc():
    """ Get existing routes """

    return {
        "/": "Supported paths",
        "/data": "Get all entries",
        "/data?ip=<ip>": "Get entries with matching ip-adress",
        "/data?url=<url>": "Get entries with matching url",
        "/data?month=<month>": "Get entries with matching month",
        "/data?day=<day>": "Get entries with matching day",
        "/data?time=<time>": "Get entries with matching time",
        "/data?ip=<ip>&url=<url>&month=<month>&day=<day>&time=<time>": "Get entries with any combination of matches",
    }



@app.get("/data")
async def get_data(
    ip: Union[str, None] = None,
    url: Union[str, None] = None,
    month: Union[str, None] = None,
    day: Union[str, None] = None,
    time: Union[str, None] = None,
):
    """ Get entries
        Optional filters: ip, url, month, day and time """

    print("*** NEW '/data' REQUEST ***")

    log = LogHandler()

    # apply filters from query parameters
    # order is relevant for speed of process of the actual log file
    filters = {
        "ip": ip,
        "time": time,
        "day": day,
        "url": url,
        "month": month,
    }

    # use handler to get and filter entries
    res = await log.filter_entries(filters)

    return res
