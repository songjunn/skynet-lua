local skynet = require "skynet"
local hotfixlib = require "hotfixlib"

local hotfix = {}

local modules = {
	--./common
	"class", "serpent", "struct", "utils",

	--./loader
	"JsonLoader", "MessageLoader",

	--./server

	--./schema
	"DBUser", "DBGlobal",

	--./manager

	--./module
	"CmdKit", "UserKit", "ItemKit", "EquipKit",

	--./handler
	"UserHandler",
}

function hotfix.reloadAll()
	for i = 1, #modules do
		hotfixlib.hotfix_module(modules[i])
	end
	skynet.logNotice("[game]reload modules over.")
end

return hotfix
