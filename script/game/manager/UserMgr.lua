local skynet = require "skynet"
local GameServer = require "GameServer"
local json = require "cjson"
local utils = require "utils"
local DBUser = require "DBUser"
local GlobalMgr = require "GlobalMgr"

local UserMgr = {}

local userlist = {}
local uuidlist = {}

function UserMgr.addUser(uid, user)
	userlist[uid] = user
end

function UserMgr.removeUser(uid)
	userlist[uid] = nil
end

function UserMgr.getUser(uid)
	return userlist[uid]
end

function UserMgr.getUserByUuid(uuid)
	return uuidlist[uuid]
end

function UserMgr.createUser(uuid)
	local user = utils.schemaTable({}, DBUser)
	local uid = GlobalMgr.generateUid()
	user.uuid = uuid
	user.userid = uid
	user.base.createtime = os.time()
	skynet.logNotice("[game]User create, uuid=%s userId=%d", uuid, uid)
	return user
end

function UserMgr.loadUser(session, uid)
    local q = {userid= uid}
    local query = json.encode(q)
    skynet.queryDb(session, "gladiator", "user", query)
end

function UserMgr.loadUserByUuid(session, uuid)
    local q = {uuid= uuid}
    local query = json.encode(q)
    skynet.queryDb(session, "gladiator", "user", query)
end

function UserMgr.saveUser(user)
    local q = {uuid = user.uuid}
    local query = json.encode(q)
    local dbuser = utils.schemaTable(user, DBUser)
    local value = json.encode(dbuser)
    skynet.upsertDb("gladiator", "user", query, value)
end

function UserMgr.setUser(jsonData)
    local dbuser = json.decode(jsonData)
    local user = utils.schemaTable(dbuser, DBUser)
    return user
end

function UserMgr.loginUser(user, fd)
	user.fd = fd
	user.base.logintime = os.time()

	skynet.logNotice("[game]User login, userId=%d fd=%d", user.userid, user.fd)
end

function UserMgr.logoutUser(user)
	user.fd = 0
	user.base.logouttime = os.time()

	skynet.logNotice("[game]User logout, userId=%d", user.userid)
end

function UserMgr.sendUserInfo(user)
	local message = {
		userid = user.userid,
		ranks = user.base.ranks,
		level = user.base.level,
		honor = user.base.honor,
		action = user.base.action,
		golden = user.base.golden,
	}
	GameServer.sendClientMsg(user.fd, message, "Message.S2CUserInfo", "S2C_USER_LOGIN")
end

return UserMgr
