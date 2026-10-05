from flask import Flask

app = Flask(__name__)

@app.route("/orders")
def orders():

    return {
        "status":"order submitted"
    }

app.run(host="0.0.0.0",port=5001)