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
	~/vscodium/vscodiumforcora/codium --enable-features=UseOzonePlatform --ozone-platform=wayland

	echo "Moving settings.json"
	mv ~/data/settings.json ~/vscodium/vscodiumforcora/data/user-data/User/

	echo "Removing settings.json" 
	rm ~/data/settings.json

	echo "Installing extensions"
	installExtensions
}

installExtensions(){
	echo "Installing recommended extensions"
	wget -O /tmp/vscode-eslint.vsix https://github.com/microsoft/vscode-eslint/releases/download/release%2F2.2.20-Insider/vscode-eslint-2.2.0.vsix
	unzip -d /tmp/vscode-eslint /tmp/vscode-eslint.vsix
	mv /tmp/vscode-eslint/extension ~/vscodium/vscodiumforcora/data/extensions/dbaeumer.vscode-eslint-2.2.0

	wget -O /tmp/prettier-vscode.vsix https://github.com/prettier/prettier-vscode/releases/download/v10.1.0/prettier-vscode-10.1.0.vsix
	unzip -d /tmp/prettier-vscode /tmp/prettier-vscode.vsix
	mv /tmp/prettier-vscode/extension ~/vscodium/vscodiumforcora/data/extensions/esbenp.prettier-vscode-10.1.0

	wget -O /tmp/codetogether.vsix https://github.com/Genuitec/CodeTogether/releases/download/2023.1.1/codetogether-2023.1.1.vsix
	unzip -d /tmp/codetogether /tmp/codetogether.vsix
	mv /tmp/codetogether/extension ~/vscodium/vscodiumforcora/data/extensions/genuitecllc.codetogether-2023.1.1

	wget -O /tmp/vscode-toggle-quotes.zip https://github.com/BriteSnow/vscode-toggle-quotes/archive/refs/tags/v0.3.6.zip
	unzip -d /tmp/vscode-toggle-quotes /tmp/vscode-toggle-quotes.zip
	mv /tmp/vscode-toggle-quotes/vscode-toggle-quotes-0.3.6 ~/vscodium/vscodiumforcora/data/extensions/

	cd ~/vscodium/vscodiumforcora/data/extensions/vscode-toggle-quotes-0.3.6
	npm install
	npm run vscode:prepublish

}

if [ ! -d ~/workspace/cora-vscodium ]; then
  	firstRun
else
	~/vscodium/vscodiumforcora/codium --enable-features=UseOzonePlatform --ozone-platform=wayland --no-sandbox
fi
