## Installation und Inbetriebnahme ##

![Alt text](Bildschirmfoto.png?raw=true "Bildschirmfoto Haltestellenmonitor ELM")

git clone https://github.com/zmijunkie/elm_haltestellen_monitor_bootstrap4.git
cd elm_haltestellen_monitor_bootstrap4


1) Python:

a) ein Kommandozeilentool zum Abfragen der VRR-API:

./app/python/haltestellenmonitor.py --help


Eine Beispielabfrage:

    ./app/python/haltestellenmonitor.py --stationId=20000131
    Dortmund, Hbf {'info': 'dyn. Fahrgastinformation', 'aufzug': 'Aufzug', 'treppe': 'Fahrtreppe', 'wc': 'WC', 'sitzen': 'Sitzgelegenheiten', 'automat': 'Fahrscheinautomat'}
    11:04h+5min | Bus 412/38012 -> Dortmund Fredenbaum
    11:01h+1min | U-Bahn U41/36001 -> Dortmund Clarenberg



b) ein Proxy der für die ELM-Anwendung auf http:localhost:5000 zur Verfügung steht:

   (Ursprünglicher Grund: Cross-Site-Scripting ist ja nicht erlaubt, irgendeine
    Art von Proxy muss da wohl her.)
    
    Eine Beispielsitzung:

    ./server.py

     * Running on http://127.0.0.1:5000/ (Press CTRL+C to quit)
     * Restarting with stat
     * Debugger is active!
     * Debugger PIN: 828-548-476
    Dortmund, Dorstfeld S {'aufzug': 'Aufzug', 'automat': 'Fahrscheinautomat', 'treppe': 'Fahrtreppe', 'sitzen': 'Sitzgelegenheiten'}
    127.0.0.1 - - [24/Sep/2017 10:52:43] "POST /abfahrten_for_station?stationId=20000196&transport=1%2C2%2C3%2C4%2C5&rowCount=10&distance=0 HTTP/1.1" 200 -
    127.0.0.1 - - [24/Sep/2017 10:59:21] "GET / HTTP/1.1" 304 -
    127.0.0.1 - - [24/Sep/2017 10:59:21] "GET /css/app.css HTTP/1.1" 304 -
    127.0.0.1 - - [24/Sep/2017 10:59:21] "GET /js/app.js HTTP/1.1" 304 -
    127.0.0.1 - - [24/Sep/2017 10:59:21] "GET /js/main.js HTTP/1.1" 304 -
    Dortmund, Dorstfeld S {'aufzug': 'Aufzug', 'automat': 'Fahrscheinautomat', 'treppe': 'Fahrtreppe', 'sitzen': 'Sitzgelegenheiten'}
    127.0.0.1 - - [24/Sep/2017 10:59:23] "POST /abfahrten_for_station?stationId=20000196&transport=1%2C2%2C3%2C4%2C5&rowCount=10&distance=0 HTTP/1.1" 200 -


2) Brunch + Elm 0.18 + Sass + Bootstrap 4

brunch watch --server

Kompiliert alles einwandfrei auf dem Master-Branch (so mein Plan). Sieht dann so aus:

        brunch watch --server
        08:56:54 - info: application started on http://localhost:3333/
        Elm compile: app/elm/Main.elm, to public/js/main.js
        08:56:56 - info: compiled 8 files into 2 files, copied 2 in 3.0 sec
        Elm compile: app/elm/Main.elm, to public/js/main.js
        08:57:49 - info: compiled Main.elm and 6 cached files into app.js in 595 ms



Das der Server auf 3333 läuft ist unnötig wir reden lieber mit dem Python-Server auf
Port 5000 und starten deswegen mit der URL http://localhost:5000 die wir in 1b) gestartet
haben. Brunch ist halt praktisch weil der kleinere Änderungen automatisch kompiliert.




LIZENZ: BSD - soweit verwendeter Sourcecode nicht eine restriktivere Lizenz hat - Hat jemand Ideen hierzu ?
        Kopierte Sourcen versuche ich per Quellenangaben zu erwähnen.

# This project uses Brunch + Elm 0.18 + Sass + Bootstrap 4 #

Some code borrowed from:
    
    https://becoming-functional.com/http-error-checking-in-elm-fee8c4b68b7b
    https://medium.com/@blogscot/learning-elm-data-types-6a25420a1b7b
