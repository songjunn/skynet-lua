local class = require "class"
local Item = require "Item"
local skynet = require "skynet"

local Equip = class()

function Equip:ctor(cfgId, num)
	--Equip.super.ctor(self, cfgId, 1)
	skynet.logDebug('Equip.ctor');
end

return Equip