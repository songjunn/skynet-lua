local skynet = require "skynet"
local GameServer = require "GameServer"
local rapidjson = require "rapidjson"
local pb = require "pb"
local serpent = require "serpent"
local utils = require "utils"
local DBUser = require "DBUser"

local UserMgr = {}

local userlist = {}

function UserMgr.addUser(uid, user)
	userlist[uid] = user
end

function UserMgr.removeUser(uid)
	userlist[uid] = nil
end

function UserMgr.getUser(uid)
	return userlist[uid]
end

function UserMgr.createUser(uid)
	local user = utils.schemaTable({}, DBUser)
	user.userid = uid
	user.base.createtime = os.time()

	skynet.logNotice("[game]User create, userId=%d", uid)
	return user
end

function UserMgr.setUser(jsonData)
    local dbuser = rapidjson.decode(jsonData)
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

function UserMgr.loadUser(session, uid)
    local q = {userid= uid}
    local query = rapidjson.encode(q)
    skynet.queryDb(session, "skynet-lua", "user", query)
end

function UserMgr.saveUser(user)
    local q = {userid = user.userid}
    local query = rapidjson.encode(q)
    local dbuser = utils.schemaTable(user, DBUser)
    local value = rapidjson.encode(dbuser)
    skynet.upsertDb("skynet-lua", "user", query, value)
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
