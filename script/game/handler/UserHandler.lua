local skynet = require "skynet"
local co = require "co"
local UserMgr = require "UserMgr"

local userHandler = {}

function userHandler.handleC2SGuestLogin(sid, fd, message)
	local uuid = message.uuid
	local user = UserMgr.getUserByUuid(uuid)
	if (user == nil) then
		UserMgr.loadUserByUuid(sid, uuid)
		data = co.yield()

		if (string.len(data) == 0) then
			user = UserMgr.createUser(uuid)
		else
            user = UserMgr.setUser(data)
        end
	end

    UserMgr.loginUser(user, fd)
    UserMgr.sendUserInfo(user)
    UserMgr.saveUser(user)
    UserMgr.addUser(user.userid, user)
end

return userHandler
