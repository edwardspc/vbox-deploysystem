DEBUG=1
LUA_EXECUTABLE=$(which lua)
SCS_HOME=$HOME/trabalho-final/scs-deploysystem
LUA_PATH="$SCS_HOME/src/lua/?.lua;$LUA_PATH"
VBOXWEB_DIR=$HOME/trabalho-final/VBoxWeb
VBOXMANAGE="$(which VBoxManage) -q"
VIRTUAL_MACHINE_START_TIMEOUT=120  # in seconds

function log() {
    if [ $DEBUG -eq 1 ]; then
        echo $*
    fi
}

