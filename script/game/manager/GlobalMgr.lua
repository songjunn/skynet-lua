local skynet = require "skynet"
local utils = require "utils"
local json = require "cjson"
local co = require "co"
local DBGlobal = require "DBGlobal"

local GlobalMgr = {}

local DBGlobalData = {}

function GlobalMgr.loadData()
    local func = function(session)
        local query = json.encode({})
        skynet.queryDb(session, "game", "global", query)
        local data = co.yield()
        if (string.len(data) == 0) then
        	DBGlobalData = utils.schemaTable(DBGlobalData, DBGlobal)
        else
        	DBGlobalData = json.decode(data)
        end
        skynet.logNotice("[game]GlobalData: %s", json.encode(DBGlobalData))
    end
    co.create(func)
end

function GlobalMgr.saveData()
    local query = json.encode({})
    local data = utils.schemaTable(DBGlobalData, DBGlobal)
    local value = json.encode(data)
    skynet.upsertDb("game", "global", query, value)
end

function GlobalMgr.generateUid()
    local id = math.floor(DBGlobalData.nextuserid)
	DBGlobalData.nextuserid = id + 1
	GlobalMgr.saveData()
	return DBGlobalData.nextuserid
end

function GlobalMgr.generateItemId()
    local id = math.floor(DBGlobalData.nextitemid)
	DBGlobalData.nextitemid = id + 1
	GlobalMgr.saveData()
	return DBGlobalData.nextitemid
end

return GlobalMgr
