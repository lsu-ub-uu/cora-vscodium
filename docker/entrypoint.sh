#! /bin/bash
VSCODIUMBRANCH=$VSCODIUMBRANCH
RECOMMENDEDSETUP=$RECOMMENDEDSETUP
echo "running entrypoint.sh..."
echo "*** using cora-vscodium branch: $VSCODIUMBRANCH ***"

firstRun(){
	git clone https://github.com/lsu-ub-uu/cora-vscodium.git ~/workspace/cora-vscodium
	if [ $VSCODIUMBRANCH != 'master' ]; then
		echo "*** checking out cora-vscodium branch: $VSCODIUMBRANCH ***"
		cd ~/workspace/cora-vscodium
		git checkout $VSCODIUMBRANCH
		cd ~
	fi

	installVSCodium
		
	chmod +x ~/workspace/cora-vscodium/development/setupProjects.sh
	~/workspace/cora-vscodium/development/setupProjects.sh ~/workspace
	
	cd ~/workspace/diva-react-client/diva-cora-ts-api-wrapper
	npm install
	npm run build

	cd ../diva-resource-fetcher
	npm install
	npm run build

	cd ../diva-react-client
	npm install
    
}

installVSCodium(){
	echo "Installing VSCodium...";
	mkdir ~/vscodium/vscodiumforcora
	wget -O - https://github.com/VSCodium/vscodium/releases/download/1.82.0.23250/VSCodium-linux-x64-1.82.0.23250.tar.gz | tar zxf - -C ~/vscodium/vscodiumforcora

	if $RECOMMENDEDSETUP; then
		setupWithRecommendedData
	else 
		echo "Skipping recommended setup"
	fi
}

setupWithRecommendedData(){
	echo "Setting up VSCodium with recommended data"
	mkdir ~/vscodium/vscodiumforcora/data

	echo "Starting VSCodium for the first time to create folder structure in data"
	~/vscodium/vscodiumforcora/codium --enable-features=UseOzonePlatform --ozone-platform=wayland --no-sandbox

	echo "Moving settings.json"
	mv ~/data/settings.json ~/vscodium/vscodiumforcora/data/user-data/User/

	echo "Removing settings.json" 
	rm ~/data/settings.json

	echo "Installing extensions"
	installExtensions
}

installExtensions(){
	# to get list of current version number
	# ~/vscodium/vscodiumforcora/bin/codium --no-sandbox --list-extensions --show-versions
	
	echo "Installing recommended extensions"
	~/vscodium/vscodiumforcora/codium --force --install-extension BriteSnow.vscode-toggle-quotes@0.3.6
	~/vscodium/vscodiumforcora/codium --force --install-extension genuitecllc.codetogether@2023.1.1

	~/vscodium/vscodiumforcora/codium --force --install-extension dbaeumer.vscode-eslint@2.4.2
	~/vscodium/vscodiumforcora/codium --force --install-extension eamodio.gitlens@13.5.0
	~/vscodium/vscodiumforcora/codium --force --install-extension esbenp.prettier-vscode@10.1.0
	~/vscodium/vscodiumforcora/codium --force --install-extension formulahendry.auto-close-tag@0.5.14
	~/vscodium/vscodiumforcora/codium --force --install-extension formulahendry.auto-rename-tag@0.1.10
	~/vscodium/vscodiumforcora/codium --force --install-extension humao.rest-client@0.25.1
	~/vscodium/vscodiumforcora/codium --force --install-extension jeff-hykin.better-dockerfile-syntax@1.0.2
	~/vscodium/vscodiumforcora/codium --force --install-extension jeff-hykin.better-shellscript-syntax@1.6.2
	~/vscodium/vscodiumforcora/codium --force --install-extension maciekkoks.luvia-theme@0.1.24
	~/vscodium/vscodiumforcora/codium --force --install-extension MartinJohns.inline-types@0.3.0
	~/vscodium/vscodiumforcora/codium --force --install-extension mhutchie.git-graph@1.30.0
	~/vscodium/vscodiumforcora/codium --force --install-extension ms-azuretools.vscode-docker@1.24.0
	~/vscodium/vscodiumforcora/codium --force --install-extension naumovs.color-highlight@2.5.0
	~/vscodium/vscodiumforcora/codium --force --install-extension Nixon.env-cmd-file-syntax@0.3.0
	~/vscodium/vscodiumforcora/codium --force --install-extension PKief.material-icon-theme@4.30.1
	~/vscodium/vscodiumforcora/codium --force --install-extension SonarSource.sonarlint-vscode@3.21.0
	~/vscodium/vscodiumforcora/codium --force --install-extension wix.vscode-import-cost@3.3.0
}

if [ ! -d ~/workspace/cora-vscodium ]; then
  	firstRun
else
	~/vscodium/vscodiumforcora/codium --enable-features=UseOzonePlatform --ozone-platform=wayland --no-sandbox
fi
