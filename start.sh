#!/bin/bash

. config.sh

# CTRL+C mata o VBoxWeb
trap "killall -v python" SIGINT



######## Configure Lua executable
log "Using lua: $LUA_EXECUTABLE"


######## Configure SCS_HOME
if [ -z $SCS_HOME ]; then
    SCS_HOME=$(dirname "$0")/scs-deploysystem
fi
export SCS_HOME
log "SCS_HOME=$SCS_HOME"


######## Configure LUA_PATH
log "LUA_PATH=$LUA_PATH"


######## Starting program
log "Starting program..."


pushd $SCS_HOME/src/lua
log "Change directory to "$PWD

log "Running the Repository..."
pushd scs/repository
./run --host=192.168.56.1 --port=2501 > repo.log 2> repo.err &
popd

log "Running the Deployment Manager and others... CTRL+C to abort"
env LUA_PATH="$LUA_PATH" $LUA_EXECUTABLE -lluarocks.require $SCS_HOME/src/lua/utils/debuglua.lua ../../../launch.lua

log -n "Restoring directory to: "
popd

log "Exit"
exit 0

