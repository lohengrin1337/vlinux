const express = require('express');
const router = express.Router();
const logModel = require('../models/log_model.js');



/* GET home page. */
router.get('/', function(req, res) {
    res.render('index', { title: 'bthlog' });
});



/* GET log page. */
router.get('/data', async function(req, res) {
    const filters = {...req.query}; // shallow copy of the query params
    const log = new logModel();
    const entries = await log.getEntries(filters);
    const count = entries.length;

    // limit entries to show current page
    const page = parseInt(req.query.page) || 1;
    const limit = 100;
    const start = (page - 1 ) * limit;
    const end = page * limit;
    const limitedEntries = entries.slice(start, end);

    console.log("*** page: ", page);

    const data = {
        title: 'bthlog',
        entries: limitedEntries,
        count: count,
        pageCount: Math.ceil(count / limit),
        page: page,
        lastFilters: filters // page: "<num>", and empty filters are removed by logModel
    };

    res.render('log', data);
});

module.exports = router;
