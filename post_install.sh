#!/bin/sh

_BASE_DIR="/usr/local"
_OVERVIEWER_DIR="$_BASE_DIR/overviewer"
_OVERVIEWER_USER="overviewer"
_OVERVIEWER_PASSWORD="overviewer"

# set the data location
DATA_LOCATION="/app-data/overviewer"

# clone the "overviewer" package
git clone git://github.com/overviewer/Minecraft-Overviewer.git $_OVERVIEWER_DIR

# get the header files required to build "overviewer"
fetch --no-verify-peer -o $_OVERVIEWER_DIR https://raw.githubusercontent.com/python-pillow/Pillow/master/src/libImaging/Imaging.h
fetch --no-verify-peer -o $_OVERVIEWER_DIR https://raw.githubusercontent.com/python-pillow/Pillow/master/src/libImaging/ImPlatform.h
fetch --no-verify-peer -o $_OVERVIEWER_DIR https://raw.githubusercontent.com/python-pillow/Pillow/master/src/libImaging/ImagingUtils.h

# build "overviewer"
python3 $_OVERVIEWER_DIR/setup.py build

# create "overviewer" user
#pw user add overviewer -c overviewer -u 353 -d /nonexistent -s /usr/bin/nologin

# create a symbolic link to "overviewer.py" file from a directory in the PATH
ln -s $_OVERVIEWER_DIR/overviewer.py $_BASE_DIR/bin/overviewer.py

# create user to run overviewer
echo $_OVERVIEWER_PASSWORD | pw user add -n $_OVERVIEWER_USER -s /bin/sh -m -h 0 -c "User for Overviewer" -G games

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
