local skynet = require "skynet"
local json = require "cjson"
local utils = require "utils"
local DBUser = require "DBUser"
local GameServer = require "GameServer"
local GlobalMgr = require "GlobalMgr"
local ItemMgr = require "ItemMgr"

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

local function string2json(key, value)
    return string.format("\"%s\":\"%s\",", key, value)
end

local function number2json(key, value)
    return string.format("\"%s\":%s,", key, value)
end

local function boolean2json(key, value)
    value = value == nil and false or value
    return string.format("\"%s\":%s,", key, tostring(value))
end

local function table2json(tab)
    local str = "{"
    for k, v in pairs(tab) do
        if type(v) == "string" then
            str = str .. string2json(k, v)
        elseif type(v) == "number" then
            str = str .. number2json(k, v)
        elseif type(v) == "boolean" then
            str = str .. boolean2json(k, v)
        elseif type(v) == "table" then
            str = str .. table2json(k, v)
        end
    end
    str = string.sub(str, 1, string.len(str) - 1)
    return str .. "}"
end

function UserKit.login(user, fd)
    user.fd = fd
    user.base.logintime = os.time()

    local item = ItemMgr.createItems(1, 3)
    print(item)
    if (item ~= nil) then
        print(item.iid)
        print("item.cfgid="..item.cfgid)
        print(item.num)
        item:cost(1)
        print("item.num="..item.num)
        skynet.logDebug(json.encode(user))
        skynet.logDebug(table2json(item))
        ItemMgr.addItem(user, item)
    end
    skynet.logDebug(json.encode(user))
    skynet.logNotice("[game]User login, userId=%d fd=%d", user.userid, user.fd)
end

function UserKit.logout(user)
    user.fd = 0
    user.base.logouttime = os.time()

    skynet.logNotice("[game]User logout, userId=%d", user.userid)
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
    GameServer.sendClientMsg(user.fd, message, "Message.S2CUserInfo", "S2C_USER_LOGIN")
end

return UserKit
