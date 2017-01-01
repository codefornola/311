var express = require('express');
var router  = express.Router();
var db      = require('./queries');

router.get('/', function(req, res, next) {
  return res.status(200).json({ message: 'This is the nola311 rest api'})
});

router.get('/calls', db.findAllCalls);
router.get('/calls/:ticketId', db.findCallsByTicketId);


module.exports = router;
