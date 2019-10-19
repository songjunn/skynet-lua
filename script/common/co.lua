local co = {}

local sid = 0
local coroutines = setmetatable({}, { __mode = "kv" })

function co.create(func, ...)
	sid = sid + 1
	local c = coroutine.create(
		function(...)
			pcall(func, sid, ...)
		end
	)
	coroutines[sid] = c
	skynet.logDebug("[game]coroutine create sid=%d", sid)
	coroutine.resume(c, ...)
end

function co.resume(sid, ...)
	local c = coroutines[sid]
	if (c == nil) then
		skynet.logError("[game]coroutine resume error sid=%d", sid)
	end
	skynet.logDebug("[game]coroutine resume sid=%d", sid)
	coroutine.resume(c, ...)
	if (coroutine.status(c) == "dead") then
		coroutines[sid] = nil
		skynet.logDebug("[game]coroutine delete sid=%d", sid)
	end
end

function co.yield(...)
	return coroutine.yield(...)
end

return co
