local co = require "co"
local UserKit = require "UserKit"
local UserMgr = require "UserMgr"

local userHandler = {}

function userHandler.handleC2SGuestLogin(sid, fd, message)
	local uuid = message.uuid
	local user = UserMgr.getUserByUuid(uuid)
	if (user == nil) then
		UserKit.loadByUuid(sid, uuid)
		data = co.yield()

		if (string.len(data) == 0) then
			user = UserKit.create(uuid)
		else
			user = UserKit.setData(data)
		end
	end

	UserKit.login(user, fd)
	UserKit.sendUserInfo(user)
	UserKit.saveDb(user)
	UserMgr.addUser(user.userid, user)
end

return userHandler
