local co = {}

local sid = 0
local coroutines = setmetatable({}, { __mode = "kv" })

function co.create(func, ...)
	local c = coroutine.create(
		function(...)
			pcall(func, ...)
		end
	)
	sid = sid + 1
	coroutines[sid] = c
	coroutine.resume(c, ...)
end

function co.resume(sid, ...)
	local c = coroutines[sid]
	if (c == nil) then
		skynet.logError("[game]coroutine resume error sid=%d", sid)
	end
	coroutine.resume(c, ...)
end

function co.yield(...)
	return coroutine.yield(...)
end

return co
