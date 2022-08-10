#! /bin/bash

USER=$1
USERID=$2
DOCKERGROUPID=$3
NOCACHE=$4
echo "running buildVSCodiumForCora.sh..."

echo "Testing for container runtimes...."
CONTAINERRUNTIME=podman;
DOCKER_EXISTS=$(command -v docker)
echo "Docker size: "${#DOCKER_EXISTS}
if [ ${#DOCKER_EXISTS} -gt 0 ]; then
	CONTAINERRUNTIME=docker;
fi
echo "Container runtime will be "${CONTAINERRUNTIME}

if [ ! $USER ]; then
  	echo you must specify the userName to be used when building vscodium1_69_2forcora1
elif [ ! $USERID ]; then
	echo you must specify the userid to be used when building vscodium1_69_2forcora1, use: id -u youruserid 
elif [ ! $DOCKERGROUPID ]; then
	echo you must specify the dockergroupid to be used when building vscodium1_69_2forcora1, use: getent group docker 
else
	#for possibly newer version of from: X
	#docker build --pull --no-cache --build-arg user=$USER --build-arg dockergroupid=$DOCKERGROUPID -t vscodiumforcoraoxygen2 cora-vscodium/docker/
#	 --no-cache \
	if [ ! $NOCACHE ]; then
		${CONTAINERRUNTIME} build \
		 --build-arg user=$USER \
		 --build-arg userid=$USERID \
		 --build-arg dockergroupid=$DOCKERGROUPID \
		 -t vscodium1_69_2forcora1 cora-vscodium/docker/
	else
		${CONTAINERRUNTIME} build --no-cache --pull \
		 --build-arg user=$USER \
		 --build-arg userid=$USERID \
		 --build-arg dockergroupid=$DOCKERGROUPID \
		 -t vscodium1_69_2forcora1 cora-vscodium/docker/
	fi
	#${CONTAINERRUNTIME} build --build-arg user=$USER -t vscodiumforcoraoxygen2 cora-vscodium/docker/
	#cd cora-vscodium/docker/
	#docker-compose build --build-arg user=$USER vscodiumforcoraoxygen2
	#docker-compose build --no-cache --build-arg user=$USER vscodiumforcoraoxygen2
fi
