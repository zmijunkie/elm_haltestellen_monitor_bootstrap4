#!/opt/local/bin/python3.4
# -*- coding: utf-8 -*-

import getopt,sys
from backend import abfahrten_for_station

def usage():
    print("""
             so benutzt man das programm zB: --stationId=20000196   (Dortmund, Dorstfeld S)
             so benutzt man das programm zB: --stationId=20001205   (Dortmund, Karl-Funke-Straße)
             so benutzt man das programm zB: --stationId=20001119   (Fine Frau)
             so benutzt man das programm zB: --stationId=20000439   (Sengsbank)
             so benutzt man das programm zB: --stationId=20000825   (Dorstfeld Süd)
             
             so benutzt man das programm zB: --stationId=20000001   (kleinste ?)
             so benutzt man das programm zB: --stationId=20009849   (grösste ?)
             
             so benutzt man das programm zB: --stationId=20000131   Dortmund, Hbf
             so benutzt man das programm zB: --stationId=20005194   Bochum, Hbf
             
             
             Abfrage mehrerer Stationen:
             so benutzt man das programm zB: --stationId=20001205,20001119,20000439,20000825,20000196
             
             Begrenzung der Anzeige auf zwei Fahrten pro Station
             
             --batch=2
             
             Abfrage in der Vergangenheit und in der Zukunft
             
             --distance=-60
             --distance=60
             
             Einschränkungen auf Verkehrsmittel
             
             --transport=0,1,2,3,4,5
             
                wobei: 0->ICE/IC/EC
                       1->Zug
                       2->S-Bahn
                       3->U-Bahn
                       4->Straßenbahn
                       5->Bus
             
             
        """)
    sys.exit(1)


def main(argv):

    stationId=None
    stationIdList=None
    batch=2
    distance=0
    transport="0,1,2,3,4,5"

    # http://217.70.161.126/HKT/Kataster.05913.html

    # http://haltestellenmonitor.vrr.de/backend/app.php/api/stations/search?query=dorstfeld    
    # {"suggestions":[{"data":"20000196","value":"Dortmund Dorstfeld S"},{"data":"20000256","value":"Dortmund AS Dorstfeld"},{"data":"20000825","value":"Dortmund Dorstfeld S\u00fcd"},{"data":"20000622","value":"Dortmund Dorstfeld Hallenbad"},{"data":"20000128","value":"Dortmund Dorstfeld Betriebshof"}]}
    
    myopts=["help","stationId=","batch=","distance=","verkehrsmittel=","transport="]
    try:
        opts, args = getopt.getopt(sys.argv[1:], "h", myopts)
    except:
        usage()
        sys.exit()
        

    for o, a in opts:
        if o in ("--stationId"):
            stationIdList=a.split(',')
        elif o in ("--batch"):
            batch=int(a)
        elif o in ("--distance"):
            distance=int(a)
        elif o in ("--transport"):
            transport=a
        elif o in ("-h", "--help"):
            usage()
            sys.exit()

    if stationIdList is None:
        usage()
        sys.exit()
        
    # now we can work
    for stationId in stationIdList:
        status_code, reason, abfahrten=abfahrten_for_station(stationId,batch,distance,transport)
        for abfahrt in abfahrten.abfahrten_list:
            print(abfahrt)



if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))

#http://stackoverflow.com/questions/12672740/ordering-with-sqlite-by-nearest-latitude-longitude-coordinates
#SELECT * AS distance FROM items ORDER BY ((location_lat-lat)*(location_lat-lat)) + ((location_lng - lng)*(location_lng - lng)) ASC
