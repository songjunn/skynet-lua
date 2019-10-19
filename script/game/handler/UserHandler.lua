local skynet = require "skynet"
local co = require "co"
local rapidjson = require "rapidjson"
local UserMgr = require "UserMgr"

local userHandler = {}

function userHandler.handleC2SUserLogin(sid, fd, message)
	local uid = message.userid
	local user = UserMgr.getUser(uid)
	if (user == nil) then
		UserMgr.loadUser(sid, uid)
		data = co.yield()

		if (data == nil) then
			user = UserMgr.createUser(uid)
		else
            user = rapidjson.decode(data)
        end
	end

    UserMgr.loginUser(user, fd)
    UserMgr.sendUserInfo(user)
    UserMgr.saveUser(user)
    UserMgr.addUser(user.userid, user)
end

return userHandler
