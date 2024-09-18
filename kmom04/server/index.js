/**
 * Main module for express server
 */

const express = require("express");
const app = express();
const port = 1337;
const routeDescription = [
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
];

function getItems() {
    const content = require("./data/items.json");

    return content.items;
}

app.get("/", (req, res) => {
    res.json(routeDescription);
});

app.get("/all", (req, res) => {
    res.json(getItems());
});

app.get("/names", (req, res) => {
    const items = getItems();
    const names = items.map(item => item.name);

    res.json(names);
});

app.get("/color/:color", (req, res) => {
    const items = getItems();
    const color = req.params.color.toLowerCase();
    const itemsOfCol = items.filter(item => item.color.some(c => c.toLowerCase() === color));

    res.json(itemsOfCol);
});

app.listen(port, () => console.log(`Listening on port ${port}`));
