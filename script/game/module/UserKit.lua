local skynet = require "skynet"
local json = require "cjson"
local utils = require "utils"
local DBUser = require "DBUser"
local Server = require "server"
local GlobalMgr = require "GlobalMgr"
local ItemKit = require "ItemKit"
local EquipKit = require "EquipKit"

local UserKit = {}

function UserKit.create(uuid)
    local user = utils.schemaTable({}, DBUser)
    local uid = GlobalMgr.generateUid()
    user.uuid = uuid
    user.userid = uid
    user.base.createtime = os.time()
    skynet.logNotice("[game]User create, uuid=%s userId=%d", uuid, uid)
    return user
end

function UserKit.load(session, uid)
    local q = {userid = uid}
    local query = json.encode(q)
    skynet.queryDb(session, "game", "user", query)
end

function UserKit.loadByUuid(session, uuid)
    local q = {uuid = uuid}
    local query = json.encode(q)
    skynet.queryDb(session, "game", "user", query)
end

function UserKit.saveDb(user)
    local q = {uuid = user.uuid}
    local query = json.encode(q)
    --local dbuser = utils.schemaTable(user, DBUser)
    local value = json.encode(user)
    skynet.upsertDb("game", "user", query, value)
end

function UserKit.setData(jsonData)
    local dbuser = json.decode(jsonData)
    --local user = utils.schemaTable(dbuser, DBUser)
    return dbuser
end

function UserKit.login(user, fd)
    user.fd = fd
    user.base.logintime = os.time()

    local item = EquipKit.createItem(10)
    if (item ~= nil) then
        skynet.logDebug(json.encode(user))
        skynet.logDebug(json.encode(item))
        ItemKit.addItem(user, item)
    end
    skynet.logDebug(json.encode(user))
    skynet.logNotice("[UserKit]User login, userId=%d fd=%d", user.userid, user.fd)
end

function UserKit.logout(user)
    user.fd = 0
    user.base.logouttime = os.time()

    skynet.logNotice("[UserKit]User logout, userId=%d", user.userid)
end

function UserKit.sendUserInfo(user)
    local message = {
        userid = user.userid,
        ranks = user.base.ranks,
        level = user.base.level,
        honor = user.base.honor,
        action = user.base.action,
        golden = user.base.golden,
    }
    Server.sendClientMsg(user.fd, message, "Message.S2CUserInfo", "S2C_USER_LOGIN")
end

return UserKit
