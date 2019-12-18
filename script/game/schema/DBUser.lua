local DBUser = {
    uuid = '', --string, 账号uuid
    userid = 0, --int64, 账号流水号
    base = {
        createtime = 0, --int64, 创建时间
        logouttime = 0, --int64, 上次退出时间
        logintime = 0, --int64, 上次登录时间
        ranks = 0, --int64, 军衔
        level = 0, --int64, 段位
        honor = 0, --int64, 荣耀值
        action = 0, --int64, 体力值
        golden = 0, --int64, 金币值
    },
}

return DBUser
