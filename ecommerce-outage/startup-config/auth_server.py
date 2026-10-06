from flask import Flask
import psycopg2

app = Flask(__name__)

DB_HOST = "10.20.20.50"
DB_NAME = "ecommerce"
DB_USER = "appuser"
DB_PASS = "password123"

@app.route("/health")
def health():
    try:
        conn = psycopg2.connect(
            host=DB_HOST,
            database=DB_NAME,
            user=DB_USER,
            password=DB_PASS
        )

        conn.close()

        return {"status":"ok"}

    except Exception as e:

        return {
            "status":"failed",
            "error": str(e)
        },500

@app.route("/login")
def login():

    try:

        conn = psycopg2.connect(
            host=DB_HOST,
            database=DB_NAME,
            user=DB_USER,
            password=DB_PASS
        )

        conn.close()

        return {
            "message":"login successful"
        }

    except Exception:

        return {
            "error":"authentication unavailable"
        },500

app.run(host="0.0.0.0",port=5000)