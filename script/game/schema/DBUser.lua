local DBUser = {
    fd = 0, --socket
    uuid = '', --string, 账号uuid
    userid = 0, --int64, 账号流水号
    base = {
        name = '', --string, 名字
        createtime = 0, --int64, 创建时间
        logouttime = 0, --int64, 上次退出时间
        logintime = 0, --int64, 上次登录时间
        level = 0, --int64, 等级
        exp = 0, --int64, 经验
        golden = 0, --int64, 金币值
    },
    itemlist = {}, --DBItem, DBEquip, 所有物品列表
}

return DBUser
