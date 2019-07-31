#!/bin/sh

_OVERVIEWER_VERSION="1.14"
_BASE_DIR="/usr/local"
_OVERVIEWER_DIR="$_BASE_DIR/overviewer"
_OVERVIEWER_UPDATE_FILE="$_OVERVIEWER_DIR/overviewer-update.sh"
_OVERVIEWER_USER="overviewer"
_OVERVIEWER_PASSWORD="overviewer"

# set the data location
_DATA_BASE="/app-data"
_DATA_LOCATION="$_DATA_BASE/overviewer"

# create the data directories
mkdir -p $_DATA_LOCATION
mkdir -p $_DATA_BASE/servers
mkdir -p $_DATA_BASE/maps

# make "overviewer" the owner of the data locations
#chown -R overviewer:overviewer /usr/local/share $DATA_LOCATION

# give write permission for plugin update
#chmod 755 $DATA_LOCATION

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

# create user to run overviewer
echo $_OVERVIEWER_PASSWORD | pw user add -n $_OVERVIEWER_USER -s /bin/sh -m -h 0 -c "User for Overviewer" -G games

# create a symbolic link to "overviewer.py" file to a directory in the PATH
ln -s $_OVERVIEWER_DIR/overviewer.py $_BASE_DIR/bin/overviewer.py

# build a file to update overviewer
echo "#!/bin/sh" >> $_OVERVIEWER_UPDATE_FILE
echo "git pull git://github.com/overviewer/Minecraft-Overviewer.git $_OVERVIEWER_DIR" >> $_OVERVIEWER_UPDATE_FILE
echo "python3 $_OVERVIEWER_DIR/setup.py build" >> $_OVERVIEWER_UPDATE_FILE

# create a symbolic link to "overviewer-update.sh" file to a directory in the PATH
ln -s $_OVERVIEWER_DIR/overviewer-update.sh $_BASE_DIR/bin/overviewer-update.sh

# get the jar file that contains the textures
fetch https://overviewer.org/textures/$_OVERVIEWER_VERSION -o $_DATA_LOCATION/jar/$_OVERVIEWER_VERSION.jar

# give execute permssion to the Daemon script
#chmod u+x /usr/local/etc/rc.d/overviewer

# enable lidarr to start at boot
#sysrc "overviewer_enable=YES"

# set the location for the data directory
#sysrc "overviewer_data_dir=$DATA_LOCATION"

# start the lidarr service
#service overviewer start
