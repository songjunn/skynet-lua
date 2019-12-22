local skynet = require "skynet"
local GlobalMgr = require "GlobalMgr"
local JsonData = require "JsonLoader"
--local ItemKit = require "ItemKit"
--local EquipKit = require "EquipKit"
local Item = require "Item"
local Equip = require "Equip"

local ItemMgr = {}

function ItemMgr.createItem(itemCfgId)
    local itemCfg = JsonData.getData('item', itemCfgId)
    if (itemCfg == nil) then 
        return nil
    end

    local item = nil
    local itemId = GlobalMgr.generateItemId()
    local itemType = math.ceil(itemCfg.type)

    print('itemType='..itemType)
    if (itemType == 1) then
        --item = ItemKit.create(itemId, itemCfg, 1)
        item = Item.new(itemCfgId, 1)
    elseif (itemType == 2) then
        --item = EquipKit.create(itemId, itemCfg, 1)
        item = Equip.new(itemCfgId, 1)
    end

    return item
end

function ItemMgr.createItems(itemCfgId, num)
    local itemCfg = JsonData.getData('item', itemCfgId)
    if (itemCfg == nil) then 
        return nil 
    end

    --if (itemCfg.stack < num) then
    --    return nil
    --end

    local item = nil
    local itemId = GlobalMgr.generateItemId()
    local itemType = math.ceil(itemCfg.type)

    print('itemType='..itemType)
    if (itemType == 1) then
        item = Item.new(itemCfgId, num)
    elseif (itemType == 2) then
        item = Equip.new(itemCfgId, num)
    end

    return item
end

function ItemMgr.addItem(user, item)
    local id = tostring(item.iid)
    user.itemlist[id] = item
    skynet.logDebug('[ItemMgr] user addItem, userId=%d itemId=%s', user.userid, id)
end

function ItemMgr.getItem(user, itemId)
    local id = tostring(itemId)
    local item = user.itemlist[id]
    return item
end

function ItemMgr.removeItem(user, itemId)
    local id = tostring(itemId)
    user.itemlist[id] = nil
    skynet.logDebug('[ItemMgr] user removeItem, userId=%d itemId=%s', user.userid, id)
end

return ItemMgr
