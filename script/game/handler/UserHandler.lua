local skynet = require "skynet"
local co = require "co"
local rapidjson = require "rapidjson"
local UserMgr = require "UserMgr"

local userHandler = {}

function userHandler.handleC2SUserLogin(sid, fd, message)
	local uid = message.userid
	--UserMgr.createUser(uid)
	local user = UserMgr.getUser(uid)
	if (user == nil) then
		UserMgr.loadUser(sid, uid)
		data = co.yield()

		if (string.len(data) == 0) then
			user = UserMgr.createUser(uid)
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
