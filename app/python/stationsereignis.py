#!/opt/local/bin/python3.4
# -*- coding: utf-8 -*-

import json

class Abfahrt(object):
    def __init__(self,departureData):
        self.departureData = departureData
    
    # __str__ goal is to be readable
    def __str__(self):
        return """{hour}:{minute}h+{delay}min | {subname} {lineNumber}/{lineCode} -> {direction}""".format(**self.departureData)
    
    # __repr__ goal is to be unambiguous
    def __repr__(self):
        return "{'abfahrt':%s}" % self.departureData

    def to_json(self):
        return {'abfahrt':self.departureData}

class Abfahrten(object):
    def __init__(self,abfahrten_list):
        self.abfahrten_list = abfahrten_list
        self.stationId = None
        self.stationInfo = None
        self.stationName = None

    def append(self,eineAbfahrt):
        self.abfahrten_list.append(eineAbfahrt)
        
    def to_json(self):
        result={}
        result['stationId']=self.stationId
        result['stationInfo']=self.stationInfo
        result['stationName']=self.stationName
        result['abfahrten']=self.abfahrten_list
        return result
        
        
class StationsereignisEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, Abfahrten):
            return obj.to_json()
        if isinstance(obj, Abfahrt):
            return obj.to_json()

        # Let the base class default method raise the TypeError
        return json.JSONEncoder.default(self, obj)

def main():
    departureData={}
    departureData['hour']=9
    departureData['minute']='00'
    departureData['delay']=1

    departureData['subname']="Bus"
    departureData['lineNumber']=9
    departureData['lineCode']=1234
    
    departureData['direction']="Wischlingen"

    
    eineAbfahrt=Abfahrt(departureData)
    print(eineAbfahrt)
    print(eineAbfahrt.__repr__() )

"""

{'year': '2016', 'subname': 'S-Bahn', 'delay': '4', 'type': 2, 'isDateOverflow': False, 'orgMinute': '56', 'directionCode': 'R', 'countdown': 1, 'orgHour': '23', 'minute': '00', 'name': 'S1', 'direction': 'Bochum Hbf', 'lineCode': '92E01', 'platform': '', 'month': '12', 'key': '26746', 'orgFullTime': 1481928960, 'fullTime': 1481929200, 'day': '17', 'supplement': '', 'lineNumber': 'S1', 'isRealTime': True, 'route': 'Dortmund Dorstfeld Süd S - Dortmund Universität S - Dortmund Oespel S - Dortmund Kley S - Bochum Langendreer S - Bochum Langendreer West - Bochum Hbf', 'hour': '0', 'orgDay': '16', 'lineInfo': {'lineBlocking': {'priority': 0, 'text': ''}, 'lineInfo': {'priority': 0, 'text': ''}}}


"""


if __name__ == "__main__":
    import sys
    sys.exit(main())
