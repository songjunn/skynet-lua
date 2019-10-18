local pb = require "pb"
local GameServer = require "GameServer"

assert(pb.loadfile "script/game/message/DBObject.pb")
assert(pb.loadfile "script/game/message/MessageTypeDefine.pb")
assert(pb.loadfile "script/game/message/MessageUser.pb")

GameServer.registMessage(pb.enum("Message.MsgDefine", "C2S_USER_LOGIN"), "Message.C2SUserLogin", require "UserHandler".handleC2SUserLogin)
