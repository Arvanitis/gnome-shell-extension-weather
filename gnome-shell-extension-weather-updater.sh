#!/bin/bash

WIRELESS_INTERFACE=eth1

LOCATION=$(wget -q --post-data="$(/bin/echo '{"version": "1.1.0","host": "maps.google.com","request_address": true,"address_language": "en_GB", "wifi_towers": [{"mac_address": "' $(iwlist $WIRELESS_INTERFACE scan | grep Address | head -1 | awk '{print $5}' | sed -e 's/ //g' ) '","signal_strength": 8,"age": 0}]}' | sed -e 's/" /"/' -e 's/ "/"/g')" -O - http://www.google.com/loc/json | sed -e 's/{/\n/g' -e 's/,/\n/g')

LATITUDE=$(echo $LOCATION | awk '{print $2}' | sed 's/"latitude"://g')
LONGITUDE=$(echo $LOCATION | awk '{print $3}' | sed 's/"longitude"://g')

YAHOO=$(curl --silent "http://where.yahooapis.com/geocode?location=$LATITUDE,$LONGITUDE&flags=J&gflags=R")

WOEID=$(echo $YAHOO | tr "," "\n" | grep woeid | sed 's/"woeid"://')

gsettings set org.gnome.shell.extensions.weather woeid $WOEID