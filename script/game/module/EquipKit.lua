local skynet = require "skynet"
local ItemKit = require "ItemKit"

local EquipKit = {}

function EquipKit.createItem(itemCfgId)
	local equip = ItemKit.createItem(itemCfgId, 1)
	skynet.logDebug('EquipKit.create itemId=%d', itemCfgId);
	return equip
end

function EquipKit.upgrade()

end

return EquipKit
