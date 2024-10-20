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

    return [{
        "/": "Supported paths",
        "/filters": "Get list of valid filters",
        "/data": "Get all entries",
        "/data?ip=<ip>": "Filter entries on ip-adress (substring, case-insensitive)",
        "/data?url=<url>": "Filter entries on url (substring, case-insensitive)",
        "/data?month=<month>": "Filter entries on month (case-insensitive)",
        "/data?day=<day>": "Filter entries on day (leading zero)",
        "/data?time=<time>": "Filter entries on time ('hh' or 'hh:mm' or 'hh:mm:ss')",
        "/data?ip=<ip>&url=<url>&month=<month>&day=<day>&time=<time>": "Filters can be used in any combination"
    }]



@app.get("/filters")
def get_filters():
    """ Get list of valid filters """
    return ["ip","url","month","day","time"]



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
