local class = require "class"
local skynet = require "skynet"

local Item = class()

function Item:ctor(cfgId, num)
	self.iid = 1
	self.cfgid = cfgId
	self.num = num
	skynet.logDebug('Item.ctor num='..num);
end

function Item:cost(num)
    if (self.num < num) then
        return false
    end
    self.num = self.num - num
    return true
end

return Item