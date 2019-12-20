local skynet = require "skynet"

local EquipKit = require "ItemKit"

function EquipKit.create(itemId, itemCfg)
	skynet.logDebug('EquipKit.create itemId=%d', itemId);
	return nil
end

function EquipKit.upgrade()

end

return EquipKit
