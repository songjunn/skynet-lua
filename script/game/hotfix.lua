local hotfix = {}

local function reload(moduleName)  
    package.loaded[moduleName] = nil  
    require(moduleName)  
end

function hotfix.reloadAll()
	--./
	reload("loader")

	--./common
	reload("class")
	reload("protoc")
	reload("serpent")
	reload("struct")
	reload("utils")

	--./server
	reload("AdminServer")

	--./manager
	reload("UserMgr")

	--./handler
	reload("UserHandler")

end

return hotfix