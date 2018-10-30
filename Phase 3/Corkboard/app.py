from src import app
from flask import g
import psycopg2


def connect_db():
    con = psycopg2.connect(dbname='mydb', host='mydbinstance.cf3ujtachi2z.us-east-1.rds.amazonaws.com',
                           port='5432', user='CS6400', password='TEAM132-Gatech')
    return con


def get_db():
    if 'db' not in g:
        g.db = connect_db()

    return g.db


@app.teardown_appcontext
def close_db(error):
    db = g.pop('db', None)

    if db is not None:
        db.close()


if __name__ == "__main__":
    app.run(debug=True)
