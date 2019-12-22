
local class = function(super)
    if super then  
        cls = {}  
        setmetatable(cls, {__index = super})  
        cls.super = super  
    else  
        cls = {ctor = function() end}  
    end  

    cls.__index = cls  
  
    function cls.new(...)
        local instance = setmetatable({}, cls)  
        instance.class = cls  
        instance:ctor(...)  
        return instance
    end
  
    return cls  
end

return class