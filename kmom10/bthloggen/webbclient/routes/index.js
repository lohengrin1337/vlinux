var express = require('express');
var router = express.Router();
var logModel = require('../models/log_model.js');

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'bthlog' });
});

/* GET log page. */
router.get('/data', async function(req, res, next) {
    const filters = req.query;

    // const filters = {
    //     url: "google.com.ph"
    // };

    const log = new logModel();
    const entries = await log.getEntries(filters);

    res.render('log', { title: 'bthlog', entries: entries, filters: filters });
  });

module.exports = router;
