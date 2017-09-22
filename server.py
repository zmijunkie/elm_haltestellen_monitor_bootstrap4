#!/Applications/Anaconda3/anaconda/bin/python

# https://www.thecodeship.com/web-development/proxypy-cross-domain-javascript-requests-python/

from flask import Flask, request, Response, render_template, send_from_directory
import json
import proxypy
import urllib.parse
import os

app = Flask(__name__,static_folder='public')

@app.route("/")
def index():
    return send_from_directory(app.static_folder, "index.html")
    
@app.route('/js/<path:filename>')
def serve_static_js(filename):
    return send_from_directory(app.static_folder + '/js/', filename)

@app.route('/css/<path:filename>')
def serve_static_css(filename):
    return send_from_directory(app.static_folder + '/css/', filename)


@app.route("/abfahrten_for_station",methods=['GET', 'POST'])
def abfahrten_for_station():
    arguments=dict(urllib.parse.parse_qsl(request.query_string)) 
    reply = proxypy.abfahrten_for_station(arguments)
    http_code=reply["status"]["http_code"]
    data=reply["content"] # '{"data": "JSON string example"}'
    return Response(data,status=http_code,mimetype='application/json')

if __name__ == "__main__":
    app.run(debug=True)
    
    
# http://127.0.0.1:5000/crossdomain?url=https://haltestellenmonitor.vrr.de/backend/app.php/api/stations/table

# https://stackoverflow.com/questions/11945523/forcing-application-json-mime-type-in-a-view-flask
# http://blog.luisrei.com/articles/flaskrest.html