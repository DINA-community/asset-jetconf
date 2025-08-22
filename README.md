# JetConf example Jukebox backend

Authors: Pavel Špírek <pavel.spirek@nic.cz>, Joerg Kippe <joerg.kippe@iosb.fraunhofer.de>

## Installation

You must first create a user called asset-manager:
```bash
useradd asset-manager
```

Then install this software at `/home/asset-manager/software/asset-jetconf/`:

```bash
sudo -iu asset-manager
mkdir software && cd software
git clone https://github.com/DINA-community/asset-jetconf
```

Run the installation script and start it:
```bash
./install.bash
./start.bash
```

## Links
- [jetconf setup guide](https://gitlab.labs.nic.cz/jetconf/jetconf-jukebox/wikis/setup)
