#! /bin/bash

workspaceDir=$1
SCRIPT=$(readlink -f "$0")
BASEDIR=$(dirname $SCRIPT)
originRepo="https://github.com/lsu-ub-uu/"

start(){
	setUser;
	importProjectListing;
	preventGitAskingForUsernameAndPasswordIfRepoIsMissing;
	addAllRepositories;
}

setUser(){
	if [ -z ${USER+x} ]; then 
		echo "USER is unset"; 
	else 
		echo "USER is set to '$USER'"; 
		user=$USER
		export user
	fi
}

importProjectListing() {
	echo "Importing projectListing"
	.  $BASEDIR/projectListing.sh
	echo $ALL
}

preventGitAskingForUsernameAndPasswordIfRepoIsMissing() {
	#export GIT_ASKPASS="/bin/true"
	export GIT_TERMINAL_PROMPT=0
	unset SSH_ASKPASS
}

addAllRepositories() {
    N=10;
	for PROJECT in $ALL; do
		((i=i%N)); ((i++==0)) && wait
		cloneRepoAndAddRemotes $PROJECT &
	done
        wait      # catch the processes that we did not wait for earlier
}

cloneRepoAndAddRemotes() {
	local projectName=$1
	 
	echo " "
	echo "..."
	echo "checking that repository and project exists:"
	echo $projectName
	setWorkingRepositoryAndProjectNameAsTemp
	echo "..."
	echo " "
	echo "clone using:"
	echo "tempRepository: $tempRepository"
	echo "tempProjectName: $tempProjectName"
	
	cd $workspaceDir
	git clone $tempRepository$tempProjectName.git $projectName
	cd $workspaceDir/$projectName
	# addOtherRemotes $projectName
	#git fetch --all
	cd $workspaceDir
}

setWorkingRepositoryAndProjectNameAsTemp(){
	tempProjectName=$projectName
	tempRepository=$originRepo

	if ! checkIfTempUrlExists; then 
		echo "- WARN - Chosen origin not found ($tempRepository$tempProjectName)"
		tryWithProjectNameWithoutCora
	fi
}

checkIfTempUrlExists(){
	local status=$(lookupUrl $tempRepository$tempProjectName)
	if [  $status -eq 200 ]; then 
		return 0
	fi
	echo "- WARN - Status for: $tempRepository$tempProjectName: $status"
	echo "Trying one more time..."
	
	local status=$(lookupUrl $tempRepository$tempProjectName)
	if [  $status -eq 200 ]; then 
		return 0
	fi
	false
}

lookupUrl(){
	local url=$1
	local status=$(curl -s --head -w %{http_code} $url --connect-timeout 10 -o /dev/null)
	echo $status
}

tryWithProjectNameWithoutCora(){
	ensureTempProjectNameDoesNotHaveCora
	
	if ! checkIfTempUrlExists; then 
		useLsuAsOrigin
	fi
	
	if ! checkIfTempUrlExists; then 
		useBelanglosAsOrigin
	fi
}

ensureTempProjectNameDoesNotHaveCora(){
	echo "Trying project name without cora..."
	if [ ${projectName:0:4} = "cora" ]; then
		tempProjectName=${projectName:5}
	#else
	fi
}

useLsuAsOrigin(){
	echo "- WARN - Falling back to using lsu as origin";
	tempProjectName=$projectName
	tempRepository="https://github.com/lsu-ub-uu/"

	if ! checkIfTempUrlExists; then
		ensureTempProjectNameDoesNotHaveCora
	fi
}

useBelanglosAsOrigin(){
	echo "- WARN - Falling back to using belanglos as origin";
	tempProjectName=$projectName
	tempRepository="https://github.com/belanglos/"

	if ! checkIfTempUrlExists; then
		ensureTempProjectNameDoesNotHaveCora
	fi
}


# ################# calls start here #######################################
if [ ! $workspaceDir ]; then
  	echo "You must specify the workspace directory.."
else
	start
fi
