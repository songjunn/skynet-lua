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

function skynet.createService(name, lib, args)
	return skynet_create_service(name, lib, args)
end

function skynet.closeService(sid)
	skynet.logDebug("closeService: %d", sid)
	skynet_close_service(sid)
end

function skynet.closeServiceByName(name)
	skynet.logDebug("closeService: %s", name)
	skynet_close_service(name)
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
	skynet_send_string("gatews", handle, fd, skynet.SERVICE_TEXT, data, #data)
end

function skynet.kickClient(fd)
	local data = "kick"
	skynet_send_string("gatews", handle, fd, skynet.SERVICE_TEXT, data, #data)
end

function skynet.selectDb(session, dbname, tablename, query, opts)
	local data = {"findmore|", dbname, "|", tablename, "|", query, "|", opts}
	local message = table.concat(data)
	skynet_send_string("database", handle, session, skynet.SERVICE_TEXT, message, #message)
end

function skynet.queryDb(session, dbname, tablename, query, opts)
	local data = {"findone|", dbname, "|", tablename, "|", query, "|", opts}
	local message = table.concat(data)
	skynet_send_string("database", handle, session, skynet.SERVICE_TEXT, message, #message)
end

function skynet.upsertDb(dbname, tablename, query, value)
	local data = {"upsert|", dbname, "|", tablename, "|", query, "|", value}
	local message = table.concat(data)
	skynet_send_string("database", handle, 0, skynet.SERVICE_TEXT, message, #message)
end

function skynet.responseHttp(target, fd, msg)
	local data = {"response|", fd, "|", msg}
	local message = table.concat(data)
	skynet_send_string(target, handle, fd, skynet.SERVICE_TEXT, message, #message)
end

function skynet.sendMessage(target, message, session)
	skynet_send_string(target, handle, session, skynet.SERVICE_TEXT, message, #message)
end

return skynet
