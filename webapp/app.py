from flask import Flask
from flask_sqlalchemy import SQLAlchemy
import os
from models import Call
from flask.json import jsonify

DEBUG = os.getenv('ENVIRONEMENT') == 'DEV'
PG_CONFIG = {
    'user': os.getenv('PG_USERNAME', 'nola311'),
    'pass': os.getenv('PG_PASSWORD', 'nola311'),
    'host': os.getenv('PG_HOST', 'localhost'),
    'port': os.getenv('PG_PORT', 5432),
    'db': os.getenv('PG_DB_NAME', 'nola311'),
}
DB_URI = 'postgresql://%(user)s:%(pass)s@%(host)s:%(port)s/%(db)s' % PG_CONFIG

db = SQLAlchemy()
app = Flask(__name__)


@app.route('/')
def root():
    return 'Welcome to the 311 webapp!'

@app.route('/calls')
def calls():
    calls = Call.query.limit(10).all()
    return jsonify([c.as_dict() for c in calls])

if __name__ == '__main__':
    app.config['DEBUG'] = DEBUG
    app.config['SQLALCHEMY_DATABASE_URI'] = DB_URI
    db.init_app(app)
    app.run()
