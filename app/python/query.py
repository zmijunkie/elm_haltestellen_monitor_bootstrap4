#!/opt/local/bin/python3.4
# -*- coding: utf-8 -*-

import urllib.parse

def add(query,masterkey,key,value):
    query+="table[{masterkey}][{key}]={value}&".format(masterkey=masterkey,key=key,value=value)
    return query

def build_query_for_station(stationId,batch=6,distance=0,transport="0,1,2,3,4,5"):
    query=""

    query=add(query,"departure","stationId",stationId) 
    query=add(query,"departure","platformVisibility","1")
    query=add(query,"departure","transport",transport)
    query=add(query,"departure","useAllLines","1")
    query=add(query,"departure","linesFilter","")
    query=add(query,"departure","rowCount",batch)
    query=add(query,"departure","distance",distance)
    query=add(query,"departure","marquee","0")
    query+="""table[sortBy]=0"""

    query_coded=urllib.parse.quote(query,safe='~@#$&()*!+=:;.?/\'')

    return query_coded


# in KLASSE umbauen wäre gut