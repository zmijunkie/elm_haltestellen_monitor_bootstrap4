#!/opt/local/bin/python3.4
# -*- coding: utf-8 -*-

import requests
import json

from query import build_query_for_station

URL='https://haltestellenmonitor.vrr.de/backend/app.php/api/stations/table'

headers = {}
headers['Accept'] = 'application/json, text/javascript, */*; q=0.01'
headers['Accept-Encoding'] = 'gzip, deflate'
headers['Accept-Language'] = 'de-DE,en;q=0.9,ru;q=0.7,es;q=0.6,de;q=0.4,nl;q=0.3,en-US;q=0.1'
headers['Content-Type'] = 'application/x-www-form-urlencoded'
headers['charset'] = 'UTF-8'
headers['Host'] = 'haltestellenmonitor.vrr.de'
headers['Referer'] = 'https://haltestellenmonitor.vrr.de/'
headers['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:49.0) Gecko/20100101 Firefox/49.0'
headers['Connection'] = 'keep-alive'
headers['DNT'] = '1'

from stationsereignis import Abfahrt,Abfahrten

def abfahrten_for_station(stationId,batch=6,distance=0,transport="0,1,2,3,4,5"):
    abfahrtenStation=Abfahrten([])
    query=build_query_for_station(stationId,batch,distance,transport)
    try:
        r = requests.post(URL, data=query, headers=headers )
    except requests.exceptions.ConnectionError:
        print("Gegenstelle antwortet nicht")
        return 503,"Gegenstelle antwortet nicht",[]
    if r.status_code==200:
       json_answer=r.json()
       # import pdb; pdb.set_trace()
       print( json_answer.get('stationName'), json_answer.get('stationInfo') )
       abfahrtenStation.stationId=stationId
       abfahrtenStation.stationName=json_answer.get('stationName')
       abfahrtenStation.stationInfo=json_answer.get('stationInfo')
       
       for departureData in json_answer.get('departureData'):
           eineAbfahrt=Abfahrt(departureData)
           abfahrtenStation.append(eineAbfahrt)
       
       return 200,"ok",abfahrtenStation

    print("ERROR stationid=%s [%s]" % ( stationId , r.status_code )  )
    return r.status_code,"nok",abfahrtenStation
       
       # json_answer.get('departureData')[0]
       # json_answer.get('departureData')[0].keys()
       # import pdb; pdb.set_trace()

def main():
    stationId="20001205"
    status_code, reason, abfahrten_karl_funke_strasse=abfahrten_for_station(stationId)
    for abfahrt in abfahrten_karl_funke_strasse.abfahrten_list:
        print(abfahrt)

    print("Ende mit dem Status: " + reason)

if __name__ == "__main__":
    import sys
    sys.exit(main())
