local UserMgr = {}

local fdlist = {}
local uuidlist = {}
local userlist = {}
local savelist = {}

function UserMgr.addUser(user)
	local fd = user.fd
	local uid = user.uid
	fdlist[fd] = user
	userlist[uid] = user
end

function UserMgr.removeUser(fd)
	local user = fdlist[fd]
	if (user ~= nil) then
		local uid = user.uid
		local uuid = user.uuid
		fdlist[fd] = nil
		userlist[uid] = nil
		uuidlist[uuid] = nil
	end
end

function UserMgr.getUser(uid)
	return userlist[uid]
end

function UserMgr.getUserByFd(fd)
	return fdlist[fd]
end

function UserMgr.getUserByUuid(uuid)
	return uuidlist[uuid]
end

return UserMgr
