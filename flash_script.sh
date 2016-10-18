#!/bin/bash

if [ $# == 0 ]; 
then
	#luatool.py --port /dev/ttyUSB0 --src init.lua --dest init.lua --verbose
	#luatool.py --port /dev/ttyUSB0 --src main.lua --dest main.lua --verbose --restart
	
	python2 nodemcu-uploader/nodemcu-uploader.py -b 9600 upload  \
			src/init.lua:init.lua \
			src/DHT11/dht11.lua:dht11.lua \
			src/main.lua:main.lua --restart


else
	if [ $1 == "init" ];
	then
		#luatool.py --port /dev/ttyUSB0 --src init.lua --dest init.lua --verbose --restart
		python2 nodemcu-uploader/nodemcu-uploader.py -b 9600 upload src/init.lua:init.lua --restart
		else if [ $1 == "main" ];
		then
			#luatool.py --port /dev/ttyUSB0 --src main.lua --dest main.lua --verbose --restart
			python2 nodemcu-uploader/nodemcu-uploader.py -b 9600 upload src/main.lua:main.lua --restart
		fi
	fi
fi
