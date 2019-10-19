local skynet = require "skynet"
local co = require "co"
local UserMgr = require "UserMgr"

local userHandler = {}

function userHandler.handleC2SUserLogin(sid, fd, message)
	local uid = message.userid
	local user = UserMgr.getUser(uid)
	if (user == nil) then
		UserMgr.loadUser(sid, uid)
		user = co.yield()

		if (string.len(user) == 0) then
			user = UserMgr.createUser(uid)
		else
			skynet.logDebug("load user:%s", user)
	end


	skynet.logDebug("user id=%d", message.userid)
end

return userHandler
