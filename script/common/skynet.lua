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

function skynet.setTimer(delay)
	skynet_timer_register(handle, "", delay)
end

function skynet.logDebug(text)
	skynet_logger_debug(handle, text)
end

function skynet.logWarn(text)
	skynet_logger_warn(handle, text)
end

function skynet.logNotice(text)
	skynet_logger_notice(handle, text)
end

function skynet.logError(text)
	skynet_logger_error(handle, text)
end

function skynet.serviceByName(name, session, type, msg)
	skynet_send_name(name, handle, session, type, msg)
end

function skynet.serviceByHandle(target, session, type, msg)
	skynet_send_handle(target, handle, session, type, msg)
end

return skynet