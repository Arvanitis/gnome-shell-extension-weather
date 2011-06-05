#!/bin/bash

#    gnome-shell-extension-weather-location-updater.sh is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    gnome-shell-extension-weather-location-updater.sh is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.


WIRELESS_INTERFACE=eth1

LOCATION=$(wget -q --post-data="$(/bin/echo '{"version": "1.1.0","host": "maps.google.com","request_address": true,"address_language": "en_GB", "wifi_towers": [{"mac_address": "' $(iwlist $WIRELESS_INTERFACE scan | grep Address | head -1 | awk '{print $5}' | sed -e 's/ //g' ) '","signal_strength": 8,"age": 0}]}' | sed -e 's/" /"/' -e 's/ "/"/g')" -O - http://www.google.com/loc/json | sed -e 's/{/\n/g' -e 's/,/\n/g')

LATITUDE=$(echo $LOCATION | awk '{print $2}' | sed 's/"latitude"://g')
LONGITUDE=$(echo $LOCATION | awk '{print $3}' | sed 's/"longitude"://g')

YAHOO=$(curl --silent "http://where.yahooapis.com/geocode?location=$LATITUDE,$LONGITUDE&flags=J&gflags=R")

WOEID=$(echo $YAHOO | tr "," "\n" | grep woeid | sed 's/"woeid"://')

gsettings set org.gnome.shell.extensions.weather woeid $WOEID

