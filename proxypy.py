""" Module for acting as a proxy for fetching contents of a url 

wget --no-check-certificate https://raw.githubusercontent.com/aymanfarhat/proxypy/master/proxypy.py
2to3 -w proxypy.py

"""
import json

import sys
sys.path.append("/Users/alex/Developer/TODO_API_Plone/haltestellenmonitor")

from backend import headers,abfahrten_for_station as backend_abfahrten_for_station
from stationsereignis import StationsereignisEncoder

def abfahrten_for_station(arguments):
    """ Builds and returns a JSON reply of all information and requested data """

    if b"stationId" not in arguments:
        reply = {}
        reply["content"] = None
        reply["status"]= {}
        reply["status"]["http_code"] = 400
        reply["status"]["reason"] = "The stationId parameter value is missing"
        return reply
    
    #
    # Below we assume correct input
    #
    
    reply = {}
    reply["headers"] = {}
    reply["status"] = {}
    # must have parameter IMHO follow:
    stationId=arguments[b"stationId"].decode("utf-8") 
    transport=arguments[b"transport"].decode("utf-8")
    rowCount=arguments[b"rowCount"].decode("utf-8")
    distance=arguments[b"distance"].decode("utf-8")

    status_code, reason, abfahrten=backend_abfahrten_for_station(stationId,batch=rowCount,distance=distance,transport=transport)

    # https://stackoverflow.com/questions/10252010/serializing-python-object-instance-to-json    
    
    if reason=="ok":
        reply["content"] = json.dumps(abfahrten,cls=StationsereignisEncoder)
        reply["status"]["http_code"] = 200
        return reply 


    # hat nicht geklappt
    reply["status"]["reason"] = reason
    reply["content"] = None 
    reply["status"]["http_code"] = status_code
   

    return reply 

