from . import db
import json
from decimal import Decimal
from datetime import date, datetime

def default(obj):
    if isinstance(obj, Decimal):
        return str(obj)
    if isinstance(obj, (datetime, date)):
        return obj.isoformat()
    raise TypeError("Object of type '%s' is not JSON serializable" % type(obj).__name__)


class Call(db.Model):
    __tablename__ = 'calls'
    id = db.Column('id', db.Integer, primary_key=True)
    ticket_id = db.Column('ticket_id', db.Numeric)
    issue_type = db.Column('issue_type', db.Text)
    ticket_created_date_time = db.Column('ticket_created_date_time', db.DateTime(True))
    ticket_closed_date_time = db.Column('ticket_closed_date_time', db.DateTime(True))
    ticket_status = db.Column('ticket_status', db.Text)
    issue_description = db.Column('issue_description', db.Text)
    street_address = db.Column('street_address', db.Text)
    neighborhood_district = db.Column('neighborhood_district', db.Text)
    council_district = db.Column('council_district', db.Text)
    city = db.Column('city', db.Text)
    state = db.Column('state', db.Text)
    zip_code = db.Column('zip_code', db.Numeric)
    location = db.Column('location', db.Text)

    # todo: find a better way to serialize the results
    def as_dict(self):
       return json.loads(json.dumps({c.name: getattr(self, c.name) for c in self.__table__.columns}, default=default))
