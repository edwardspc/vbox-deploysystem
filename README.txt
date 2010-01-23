-------------------------------------------------------------------------------
A virtual machine integration approach for building Execution Nodes
in a SCS Deployment System (http://www.tecgraf.puc-rio.br/scs). This
allow to instantiate VirtualBox virtual machines for selection of 
a host according the platform required.
-------------------------------------------------------------------------------

-----------
Requisites
-----------
1. VirtualBox 3.1 installed
2. Download the tarball "vbox-deploysystem-01alfa.tar.bz2"
3. Download the virtual appliance image "ubuntu-image.vdi"

------------
Basic Steps
------------
1. Untar the vbox-deploysystem-01alfa.tar.bz2
2. cd vbox-deploysystem-01alfa
3. ./start.sh
4. cd $HOME/vbox-deploysystem-01alfa/scs-deploysystem/src/lua/scs/demos/deployer
5. ./rundemo hello-packaging.lua
6. ./rundemo hello-deployment.lua
7. ./rundemo hello-deployment-tests.lua

-----------------
More Information
-----------------
1. SCS Deployment System 0.4
   http://www.tecgraf.puc-rio.br/scs
2. VirtualBox 3.1
   http://www.virtualbox.org/
3. VBoxWeb(optional)
   http://code.google.com/p/vboxweb/
------
Notes
------
- Tested on Ubuntu 9.10


#
# Basic Steps
#
1. Check if the interface vboxnet0 is up.
2. ./start.sh
3. hello-packaging.lua
4. hello-deployment.lua

# Arquivo de teste que gera 3 maquinas virtuais
hello-deployment-tests.lua

# NOTE
For testing im using VBoxSDL instead of VBoxWeb.


