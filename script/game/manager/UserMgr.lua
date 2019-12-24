local UserMgr = {}

local fdlist = {}
local uuidlist = {}
local userlist = {}
local savelist = {}

function UserMgr.addUserByFd(fd, user)
	fdlist[fd] = user
end

function UserMgr.addUser(uid, user)
	userlist[uid] = user
end

function UserMgr.removeUser(uid)
	local user = userlist[uid]
	if (user ~= nil) then
		local uuid = user.uuid
		userlist[uid] = nil
		uuidlist[uuid] = nil
	end
end

function UserMgr.getUser(uid)
	return userlist[uid]
end

function UserMgr.getUserByUuid(uuid)
	return uuidlist[uuid]
end

return UserMgr
