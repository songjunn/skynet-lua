local class = require "class"
local Item = require "Item"
local skynet = require "skynet"

local Equip = class(Item)

function Equip:ctor(cfgId)
	Equip.super.ctor(self, cfgId, 1)
	skynet.logDebug('Equip.ctor');
end

return Equip