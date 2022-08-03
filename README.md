# To get started

- Create a folder which will contain the installations of cora-vscodium, e.g. `mkdir parentDir`
- `cd parentDir`
- Clone this repo, e.g. `git clone https://github.com/lsu-ub-uu/cora-vscodium/`
- Make the main install script executable `chmod +x ./cora-vscodium/runAll.sh`


# First installation:
After the steps above
1. cd into the parentDir
2. Have your dockerId ready, to get it run `getent group docker`
3. run `./cora-vscodium/runAll.sh <your-docker-id> true`, replace `<your-docker-id>` with your docker id.
4. When VSCodium starts for the first time, just close it and let the install continue, the startup is needed to create the correct folder structure
5. When the installation is done you should see the following files/directories:

```
parentDir
|- cora-vscodium/
|- env.sh
|- startCurrentVSCodiumForCora.sh
|- vscodium1_69_2forcora1/
```
#
1. To start, run `./startCurrentVSCodiumForCora.sh` from your parentDir.
2. Go through the "Get Started with VS Code" sections, or just choose your color theme and "Mark Done"
3. "Open Folder" `workspace/cora-react-client`
4. If asked "Do you trust the authors of the files in this folder?" you can confirm if you want, check the checkbox if you plan to only clone repos into workspace that you trust
5. Follow the steps in https://github.com/lsu-ub-uu/cora-react-client/ "To get started", skip step 1.


# To be able to push to Github

into your parentDir, put a .gitconfig file with content:

```
[credential]
        helper = store
[user]
        name = yourname
        email = youremail
```

As well as a .git-credentials file with content:
``` 
https://[yourgithubusername]:[youraccesstoken]@github.com
```
        
The access token only has to have public_repo access.

Your parentDir should look like this now (ls -ahl):
```
parentDir
|- cora-vscodium/
|- vscodium1_69_2forcora1/
|- env.sh
|- .gitconfig
|- .git-credentials
|- startCurrentVSCodiumForCora.sh
```

# To update to a new version
1. cd into the parentDir
2. Have your dockerId ready, to get it run `getent group docker`
3. run `./cora-vscodium/runAll.sh <your-docker-id> false master nocache`, replace `<your-docker-id>` with your docker id.
