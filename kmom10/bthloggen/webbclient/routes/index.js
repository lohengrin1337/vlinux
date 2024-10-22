const express = require('express');
const router = express.Router();
const logModel = require('../models/log_model.js');

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'bthlog' });
});

/* GET log page. */
router.get('/data', async function(req, res, next) {
    const filters = req.query;
    const log = new logModel();
    const entries = await log.getEntries(filters);
    const count = Object.keys(entries).length;
    const data = {
        title: 'bthlog',
        entries: entries,
        count: count
    };

    res.render('log', data);
});

module.exports = router;
