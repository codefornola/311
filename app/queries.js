var promise = require('bluebird');

var options = {
  promiseLib: promise
};

var pgp = require('pg-promise')(options);
var dbUrl = process.env.DATABASE_URL || 'postgres://localhost:5432/nola311';
var db = pgp(dbUrl);

function findAllCalls(req, res, next) {
  let pageSize = req.query.pageSize ? parseInt(req.query.pageSize) : 50;

  db.any('select * from nola311.calls limit $1', pageSize)
    .then(function (data) {
      res.status(200).json({ status: 'success', data: data });
    })
    .catch(function (err) {
      return next(err);
    });
}

function findCallsByTicketId(req, res, next) {
  let ticketId = req.params.ticketId;

  db.one('select * from nola311.calls where ticket_id=$1', ticketId)
    .then(function (data) {
      res.status(200).json({ status: 'success', data: data });
    })
    .catch(function (err) {
      return next(err);
    });
}

function findCallTypeTotals(req, res, next) {
  db.any('with totals as (select count(*) as total, issue_type from nola311.calls group by issue_type order by total desc) select issue_type, total from totals')
    .then(function (data) {
      console.log(data);
      res.status(200).json({ status: 'success', data: data });
    })
    .catch(function (err) {
      return next(err);
    });
}

module.exports = {
    findAllCalls: findAllCalls,
    findCallsByTicketId: findCallsByTicketId,
    findCallTypeTotals: findCallTypeTotals,
};
