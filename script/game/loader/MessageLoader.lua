local pb = require "pb"
local skynet = require "skynet"
local GameServer = require "GameServer"

local MessageLoader = {}

function MessageLoader.loadAll()
	assert(pb.loadfile "script/game/message/MessageTypeDefine.pb")
	assert(pb.loadfile "script/game/message/MessageUser.pb")

	GameServer.registMessage(pb.enum("Message.MsgDefine", "C2S_GUEST_LOGIN"), "Message.C2SGuestLogin", require "UserHandler".handleC2SGuestLogin)
	--GameServer.registMessage(pb.enum("Message.MsgDefine", "C2S_USER_LOGIN"), "Message.C2SUserLogin", require "UserHandler".handleC2SUserLogin)

	skynet.logNotice("[game]load messages over.")
end

return MessageLoader
