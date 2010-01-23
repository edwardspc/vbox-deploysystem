--- Starts the DeployManager and the Packager services
local oil = require "oil"
oil.verbose:level(tonumber(arg[1]) or 4) -- using first arg as verbosity level
-- local of the corba idl files installation
local SCS_HOME = assert(os.getenv("SCS_HOME"), 
                 "Missing the system variable called SCS_HOME")

-- new orb instance publicy accessible
orb = oil.init{ host = "192.168.56.1", port = 2500, tcpoptions = { reuseaddr = true } }
oil.orb = orb
orb:loadidlfile(SCS_HOME.."/idl/deployer.idl")
orb:loadidlfile(SCS_HOME.."/idl/repository.idl")

oil.main(function()

  -- new instance of a DeployManager
  Manager = require "scs.deployer.Manager"
  managerServant = Manager()
--[[AMADEU: should execute as following:
--1. cd scs-deploysystem/src/lua/scs/repository/
--2. ./run --host=192.168.56.1 --port=2501
  -- new instance of a Repository
  Repository = require "scs.repository.ComponentRepository"
  repo = orb:narrow(Repository:create({"."}))
  -- hack to shutdown this simple server too!
  repo.shutdown_original = repo.shutdown
  repo.shutdown = function(self)
    repo:shutdown_original()
    orb:shutdown()
    print("Repository as shutdown...")
  end
  repo:startup()
]]  
  oil.newthread(orb.run,orb)

--[[  print("Registering repository as public repository")
  --RepositoryEntity = require "scs.deployer.Manager.RepositoryEntity"
  ]]

  plan = managerServant:create_plan()
  plan:mark_as_admin( true )
  repositoryHost = { name= "jaku", ip = "192.168.56.1", port = 2501 }
  repo = plan:create_repository()
  repo:set_host( repositoryHost )
  repo:set_privacy( false ) -- public
  print("[info] repository planned: ",repo:get_nickname())

  repo:deploy() -- deployment step
  print("[info] repository deployed!")
  print("[info] waiting for 2 seconds...")
  oil.sleep(2)

  repo:activate() -- activation step
  print("[info] repository is activated!")
  
  -- new instance of a Packager
  Packager = require "scs.deployer.Packager"
  packagerServant = Packager()

  
  print("**********************************************************")
  print("Deployer, Repository and Packager serving on port 2500")
  print("**********************************************************")
  print("Repository IOR")
  print(orb:tostring(repo))
  print()
  print("Deployer IOR")
  print(orb:tostring(managerServant))
  print()
  
  
  
  print("Starting VirtualBoxWeb...")
  --EDWARD: local stdout = io.popen("../../../start-vboxweb.sh "..orb:tostring(managerServant).." "..orb:tostring(repo), "r");
  os.execute("../../../start-vboxweb.sh "..orb:tostring(managerServant).." "..orb:tostring(repo).." > ../../../vboxweb.log 2>../../../vboxweb.err &")
  --for line in stdout:lines() do
  --  print(line);
  --end
  
  -- waiting for incomming connections
  --orb:run()
  
  --stdout:close()
end)
