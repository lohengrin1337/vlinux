const express = require('express');
const router = express.Router();
const logModel = require('../models/log_model.js');

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'bthlog' });
});

/* GET log page. */
router.get('/data', async function(req, res, next) {
    const page = parseInt(req.query.page) || 1;
    const filters = req.query;
    const log = new logModel();
    const entries = await log.getEntries(filters);
    const count = entries.length;

    console.log("*** page: ", page);

    const limit = 100;
    const start = (page - 1 ) * limit;
    const end = page * limit;
    const limitedEntries = entries.slice(start, end);

    const data = {
        title: 'bthlog',
        entries: limitedEntries,
        count: count,
        pageCount: Math.ceil(count / limit),
        hasMore: count > end,
        nextPage: page + 1,
        lastFilters: filters
    };

    res.render('log', data);
});

module.exports = router;
