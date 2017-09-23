## Installation ##



git clone https://github.com/zmijunkie/elm_haltestellen_monitor_bootstrap4.git


Python:

./server.py

Kann zur Zeit nicht starten - einige Python-Module habe ich noch nicht commited - kommt in Kürze.

*WIRD BENÖTIGT FALLS IHR EUCH IN ELM ETWAS ANDERES ALS EINEN NETZWERKFEHLER ANSCHAUEN WOLLT ;-)  *


Brunch:

brunch watch --server

Kompiliert alles einwandfrei auf dem Master-Branch (so mein Plan). Sieht dann so aus:

        brunch watch --server
        08:56:54 - info: application started on http://localhost:3333/
        Elm compile: app/elm/Main.elm, to public/js/main.js
        08:56:56 - info: compiled 8 files into 2 files, copied 2 in 3.0 sec
        Elm compile: app/elm/Main.elm, to public/js/main.js
        08:57:49 - info: compiled Main.elm and 6 cached files into app.js in 595 ms



Das der Server auf 3333 läuft ist unnötig wir reden lieber mit dem Python-Server auf
Port 5000 und starten deswegen mit der URL http://localhost:5000




LIZENZ: BSD - soweit verwendeter Sourcecode nicht eine restriktivere Lizenz hat - Hat jemand Ideen hierzu ?
        Kopierte Sourcen versuche ich per Quellenangaben zu erwähnen.

# This project uses Brunch + Elm 0.18 + Sass + Bootstrap 4 #

Some code borrowed from:
    
    https://becoming-functional.com/http-error-checking-in-elm-fee8c4b68b7b