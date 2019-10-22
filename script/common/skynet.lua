local skynet = {
	SERVICE_TEXT = 0,
	SERVICE_SOCKET = 1,
	SERVICE_TIMER = 2,
	SERVICE_REMOTE = 3,
	SERVICE_RESPONSE = 4,
}

local handle

function skynet.setHandle(id)
	handle = id
end

function skynet.getHandle()
	return handle
end

function skynet.setTimer(delay)
	skynet_timer_register(handle, "", delay)
end

function skynet.logDebug(fmt, ...)
	local text = string.format(fmt, ...)
	skynet_logger_debug(handle, text)
end

function skynet.logWarn(fmt, ...)
	local text = string.format(fmt, ...)
	skynet_logger_warn(handle, text)
end

function skynet.logNotice(fmt, ...)
	local text = string.format(fmt, ...)
	skynet_logger_notice(handle, text)
end

function skynet.logError(fmt, ...)
	local text = string.format(fmt, ...)
	skynet_logger_error(handle, text)
end

function skynet.serviceByName(name, session, type, msg)
	skynet_send_name(name, handle, session, type, msg)
end

function skynet.serviceByHandle(target, session, type, msg)
	skynet_send_handle(target, handle, session, type, msg)
end

function skynet.sendClient(fd, msg)
	local data = string.format("forward|%s", msg)
	skynet.serviceByName("gatews", fd, skynet.SERVICE_TEXT, data)
end

function skynet.kickClient(fd)
	skynet.serviceByName("gatews", fd, skynet.SERVICE_TEXT, "kick")
end

function skynet.queryDb(session, dbname, tablename, query)
	local data = string.format("findone|%s|%s|%s", dbname, tablename, query)
	skynet.serviceByName("database", session, skynet.SERVICE_TEXT, data)
end

function skynet.upsertDb(dbname, tablename, query, value)
	local data = string.format("upsert|%s|%s|%s|%s", dbname, tablename, query, value)
	skynet.serviceByName("database", 0, skynet.SERVICE_TEXT, data)
end

function skynet.responseHttp(target, fd, msg)
	local data = string.format("response|%d|%s", fd, msg)
	skynet.serviceByHandle(target, fd, skynet.SERVICE_TEXT, data)
end

return skynet
