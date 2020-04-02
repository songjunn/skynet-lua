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

function skynet.sendClient(fd, msg)
	local data = string.format("forward|%s", msg)
	skynet_send_string("gatews", handle, fd, skynet.SERVICE_TEXT, data, string.len(data))
end

function skynet.kickClient(fd)
	local data = "kick"
	skynet_send_string("gatews", handle, fd, skynet.SERVICE_TEXT, data, string.len(data))
end

function skynet.selectDb(session, dbname, tablename, query)
	local data = string.format("findmore|%s|%s|%s", dbname, tablename, query)
	skynet_send_string("database", handle, session, skynet.SERVICE_TEXT, data, string.len(data))
end

function skynet.queryDb(session, dbname, tablename, query)
	local data = string.format("findone|%s|%s|%s", dbname, tablename, query)
	skynet_send_string("database", handle, session, skynet.SERVICE_TEXT, data, string.len(data))
end

function skynet.upsertDb(dbname, tablename, query, value)
	local data = string.format("upsert|%s|%s|%s|%s", dbname, tablename, query, value, string.len(data))
	skynet_send_string("database", handle, 0, skynet.SERVICE_TEXT, data, string.len(data))
end

function skynet.responseHttp(target, fd, msg)
	local data = string.format("response|%d|%s", fd, msg)
	skynet_send_string(target, handle, fd, skynet.SERVICE_TEXT, data, string.len(data))
end

return skynet
