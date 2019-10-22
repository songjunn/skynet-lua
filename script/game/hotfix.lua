local skynet = require "skynet"

local hotfix = {}

local modules = {
	--./common
	"class", "protoc", "serpent", "struct", "utils",

	--./loader
	"JsonLoader", "MessageLoader",

	--./server
	"AdminServer",

	--./manager
	"UserMgr",

	--./handler
	"UserHandler",
}

function hotfix.reloadAll()
	for i = 1, #modules do
		package.loaded[modules[i]] = nil
	end
	for i = 1, #modules do
		require(modules[i])
	end
	skynet.logNotice("[game]reload modules over.")
end

return hotfix
