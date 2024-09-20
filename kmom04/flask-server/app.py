#!/usr/bin/env python3

#
# Main module for Flask server
#

from flask import Flask
import json

app = Flask(__name__)


#
# UTILS
#

# get items from json-file
def get_items():
    with open("./data/items.json", "r") as file:
        data = json.load(file)
    return data["items"]

# determine case-insensitive color match
def has_color(color, item):
    return any(color.lower() == c.lower() for c in item["color"])



#
# ROUTES
#

@app.route("/")
def route_description():
    return [
    {
        "route": "/",
        "description": "Presentation of all routes"
    },
    {
        "route": "/all",
        "description": "Presentation of all items"
    },
    {
        "route": "/names",
        "description": "Presentation of all names"
    },
    {
        "route": "/color/A-COLOR",
        "description": "Presentation of items with specified color 'A-COLOR'"
    }
]

@app.route("/all")
def all_items():
    return get_items()

@app.route("/names")
def all_names():
    all_names = [item["name"] for item in get_items()]
    return all_names

@app.route("/color/<string:color>")
def items_of_color(color):
    items_of_color = [item for item in get_items() if has_color(color, item)]
    return items_of_color



if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0")
