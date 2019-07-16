#!/bin/sh

_BASE_DIR="/usr/local"
_OVERVIEWER_DIR="$_BASE_DIR"

# set the data location
DATA_LOCATION="/app-data/overviewer"

# clone the "overviewer" package
git clone git://github.com/overviewer/Minecraft-Overviewer.git 

# get the header files required to build "overviewer"
fetch --no-verify-peer -o $_OVERVIEWER_DIR/ https://raw.githubusercontent.com/python-pillow/Pillow/master/src/libImaging/Imaging.h
fetch --no-verify-peer -o $_OVERVIEWER_DIR/ https://raw.githubusercontent.com/python-pillow/Pillow/master/src/libImaging/ImPlatform.h
fetch --no-verify-peer -o $_OVERVIEWER_DIR/ https://raw.githubusercontent.com/python-pillow/Pillow/master/src/libImaging/ImagingUtils.h

# build "overviewer"
./python3 setup.py build

# create "overviewer" user
pw user add overviewer -c overviewer -u 353 -d /nonexistent -s /usr/bin/nologin

# create the data location
#mkdir -p $DATA_LOCATION

# make "overviewer" the owner of the install and data locations
#chown -R overviewer:overviewer /usr/local/share $DATA_LOCATION

# give write permission for plugin update
#chmod 755 $DATA_LOCATION

# give execute permssion to the Daemon script
#chmod u+x /usr/local/etc/rc.d/overviewer

# enable lidarr to start at boot
#sysrc "overviewer_enable=YES"

# set the location for the data directory
#sysrc "overviewer_data_dir=$DATA_LOCATION"

# start the lidarr service
#service overviewer start
