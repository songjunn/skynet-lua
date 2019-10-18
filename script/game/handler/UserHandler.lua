local skynet = require "skynet"

local userHandler = {}

function userHandler.handleC2SUserLogin(fd, message)
	skynet.logDebug("user id=%d", message.userid)
end

return userHandler
