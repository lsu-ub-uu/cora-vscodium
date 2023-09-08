#! /bin/bash

echo "Running setupDirectoriesAndScriptsForVSCodiumForCora..."

#USER=$1
SCRIPT=$(readlink -f "$0")
BASEDIR=$(dirname $SCRIPT)
PARENTDIR="$(dirname "$BASEDIR")"
INSTALLVERSION=vscodium1_82_0forcora
INSTALLDIR=$PARENTDIR/$INSTALLVERSION
TOPDIR="$(dirname "$PARENTDIR")"

echo 
echo script: $SCRIPT
echo basedir: $BASEDIR
echo parentdir: $PARENTDIR
echo installdir: $INSTALLDIR

createDirectories(){
  	mkdir $INSTALLDIR
 	mkdir $INSTALLDIR/vscodium
  	mkdir $INSTALLDIR/workspace
}
	
changeAndCopyScripts(){
	cp $BASEDIR/startVSCodiumForCora.sh $INSTALLDIR/
	sed -i "s|INSTALLDIR|$INSTALLDIR|g" $INSTALLDIR/startVSCodiumForCora.sh
	sed -i "s|PARENTDIR|$PARENTDIR|g" $INSTALLDIR/startVSCodiumForCora.sh

	cp $BASEDIR/startVSCodiumForCoraTempSetup.sh $INSTALLDIR/
	sed -i "s|INSTALLDIR|$INSTALLDIR|g" $INSTALLDIR/startVSCodiumForCoraTempSetup.sh
	sed -i "s|PARENTDIR|$PARENTDIR|g" $INSTALLDIR/startVSCodiumForCoraTempSetup.sh

	# cp $BASEDIR/startVSCodiumForCoraNoPorts.sh $INSTALLDIR/
	# sed -i "s|INSTALLDIR|$INSTALLDIR|g" $INSTALLDIR/startVSCodiumForCoraNoPorts.sh
	# sed -i "s|PARENTDIR|$PARENTDIR|g" $INSTALLDIR/startVSCodiumForCoraNoPorts.sh
	
	# cp $BASEDIR/development/projectListing.sh $INSTALLDIR/projectListing.sh
	# cp $BASEDIR/development/setupProjects.sh $INSTALLDIR/setupProjects.sh
	
	# cp $BASEDIR/docker/docker-compose.yml $INSTALLDIR/
	cp $BASEDIR/docker/Dockerfile $INSTALLDIR/
	cp $BASEDIR/docker/entrypoint.sh $INSTALLDIR/
	
	# cp $BASEDIR/docker/derived $INSTALLDIR/workspace/.derived
}

createGitConfigFile(){
	touch $PARENTDIR/.gitconfig
	touch $PARENTDIR/.git-credentials
}

if [ ! -d $INSTALLDIR ]; then
	createDirectories
	changeAndCopyScripts
	createGitConfigFile
fi

