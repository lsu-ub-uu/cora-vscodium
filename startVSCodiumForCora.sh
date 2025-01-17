#! /bin/bash
SCRIPT=$(readlink -f "$0")
BASEDIR=$(dirname $SCRIPT)
echo basedir: $BASEDIR

USER=$(id -u -n)

echo 
echo starting VSCodium using:
echo userName: $USER
echo 
echo "Testing for container runtimes...."
CONTAINERRUNTIME=podman;
DOCKER_EXISTS=$(command -v docker)
echo "Docker size: "${#DOCKER_EXISTS}
if [ ${#DOCKER_EXISTS} -gt 0 ]; then
	CONTAINERRUNTIME=docker;
fi
echo "Container runtime will be "${CONTAINERRUNTIME}

if [ ! $USER ]; then
  	echo "You must specify the userName used when starting vscodium1_82_0forcora3"
else
	#${CONTAINERRUNTIME} run --rm -ti --privileged --ipc=host --env="QT_X11_NO_MITSHM=1"  -e DISPLAY=$DISPLAY \
cd vscodium1_82_0forcora3
${CONTAINERRUNTIME} run --rm -ti --privileged  --ipc=host \
 --env="QT_X11_NO_MITSHM=1"\
 --env="NO_AT_BRIDGE=1"\
 -e DISPLAY=$DISPLAY \
 -e XDG_RUNTIME_DIR=/tmp \
 -e WAYLAND_DISPLAY=$WAYLAND_DISPLAY \
 -v $XDG_RUNTIME_DIR/$WAYLAND_DISPLAY:/tmp/$WAYLAND_DISPLAY \
 -v /var/run/docker.sock:/var/run/docker.sock\
 -v /usr/lib64/dri:/usr/lib64/dri\
 -v /tmp/.X11-unix:/tmp/.X11-unix\
 -v INSTALLDIR/workspace:/home/$USER/workspace\
 -v INSTALLDIR/vscodium:/home/$USER/vscodium\
 -v PARENTDIR/.gitconfig:/home/$USER/.gitconfig\
 -v PARENTDIR/.git-credentials:/home/$USER/.git-credentials\
 -e user=$USER\
 -e HOSTBASEDIR=$BASEDIR\
 -p 33001:3000\
 --name vscodium1_82_0forcora3\
 vscodium1_82_0forcora3 $2
 cd ../
fi

