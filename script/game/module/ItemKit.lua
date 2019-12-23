local class = require "class"
local utils = require "utils"
local skynet = require "skynet"
local DBItem = require "DBItem"
local JsonData = require "JsonLoader"
local GlobalMgr = require "GlobalMgr"

local ItemKit = {}

function ItemKit.createItem(itemCfgId, num)
    local itemCfg = JsonData.getData('item', itemCfgId)
    if (itemCfg == nil) then 
        return nil
    end

    local stackmax = math.floor(itemCfg.stackmax)
    if (stackmax < num) then
        return nil
    end

    local item = utils.schemaTable({}, DBItem)
    item.iid = GlobalMgr.generateItemId()
    item.cfgId = itemCfg['id']
    item.num = num
    return item
end

function ItemKit.addItem(user, item)
    local id = tostring(item.iid)
    user.itemlist[id] = item
    skynet.logDebug('[ItemKit] user addItem, userId=%d itemId=%s', user.userid, id)
end

function ItemKit.getItem(user, itemId)
    local id = tostring(itemId)
    local item = user.itemlist[id]
    return item
end

function ItemKit.removeItem(user, itemId)
    local id = tostring(itemId)
    user.itemlist[id] = nil
    skynet.logDebug('[ItemKit] user removeItem, userId=%d itemId=%s', user.userid, id)
end

function ItemKit.costItem(user, item, num)
    if (item.num < num) then
        return false
    end
    item.num = item.num - num

    if (item.num <= 0) then
        ItemKit.removeItem(user, item.iid)
    end

    return true
end

return ItemKit
