local skynet = require "skynet"

local Server = {}

local harbor

function Server.startup(id)
	harbor = id
end

function Server.shutdown()

end

function Server.tick()
	--skynet.logDebug("game server tick")
end

return Server