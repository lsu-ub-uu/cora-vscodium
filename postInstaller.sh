#!/bin/bash
echo "Running postInstaller";

RECOMMENDEDSETUP=${1:-false}
SCRIPT=$(readlink -f "$0")
BASEDIR=$(dirname $SCRIPT)
PARENTDIR="$(dirname "$BASEDIR")"
INSTALLVERSION=vscodium1_82_0forcora2
INSTALLDIR=$PARENTDIR/$INSTALLVERSION

updateOrCreateEnv(){
	local FILENAME=env.sh
	local FILE=${PARENTDIR}/${FILENAME}
	echo $FILE

	if [ ! -f "${FILE}" ]; then
			echo "$FILENAME does not exist in $PARENTDIR, attempting to create it."
			touch "${FILE}"
			echo "CURRENTVERSION=$INSTALLVERSION" > ${FILE}
	else
			echo "$FILE exists."
			. $FILE
			echo "Current version: $CURRENTVERSION, updating to $INSTALLVERSION"
			sed -i "s/$CURRENTVERSION/$INSTALLVERSION/g" $FILE
	fi
}

createStartScriptIfNotExists(){
	local FILENAME=startCurrentVSCodiumForCora.sh
	local FILE=${PARENTDIR}/${FILENAME}

    if [ ! -f "${FILE}" ]; then
        echo "$FILENAME does not exist in $PARENTDIR, attempting to create it."
        cp $BASEDIR/$FILENAME $PARENTDIR/
        chmod +x ${FILE}
	fi
}

setupStartScriptInParentFolder(){
	echo "Setting up start script in $PARENTDIR folder"
	updateOrCreateEnv
	createStartScriptIfNotExists
}

if ! $RECOMMENDEDSETUP; then
    . $PARENTDIR/env.sh
    TARGET=$INSTALLDIR/vscodium/vscodiumforcora/
    echo Copying files from $CURRENTVERSION to $TARGET
    cp -r $PARENTDIR/$CURRENTVERSION/vscodium/vscodiumforcora/data $TARGET
fi

setupStartScriptInParentFolder
