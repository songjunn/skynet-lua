local utils = require "utils"
local DBItem = require "DBItem"
local ItemMgr = require "ItemMgr"

local ItemKit = {}

function ItemKit.create(itemId, itemCfg, num)
    local item = utils.schemaTable({}, DBItem)
    item.iid = itemId
    item.cfgId = itemCfg.id
    item.num = num;
    return item
end

function ItemKit.cost(user, item, num)
    if (item.num < num) then
        return false
    end
    item.num = item.num - num

    if (item.num <= 0) then
        ItemMgr.removeItem(user, item.iid)
    end

    return true
end

return ItemKit
