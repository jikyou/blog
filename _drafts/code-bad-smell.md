## 代码的坏味道

### 嵌套的 for if。

1. 函数式 map reduce filter。

### 多层 if 嵌套。

1. guard code 卫语句。

```ts
let invF = { type: "none", name: "", maxcount: 0 }
let cfg = await roleRPC.inst.loadActiveCfg(param.id, param.activeId);
if (!cfg.forceMember) {
    // 第一次强制入会的时候把字段加上
    await roleRPC.inst.setActiveCfg(param.id, param.activeId, { forceMember: true });
    if (param.inviteUid) {
        let activeInfo = await activeRPC.getActive(param.activeId) as ifActiveInfo;

        // 两个接口的逻辑是一样的，只是完成的任务不一样，若态是完成的好友邀请任务，其他的完成的是邀请入会任务
        if (activeInfo.gameId == "ruotaizhongshu") {
            invF = await roleRPC.inst.checkFriendLink(param.id, param.activeId, param.inviteUid);
        } else {
            invF = await roleRPC.inst.checkMemberLink(param.id, param.activeId, param.inviteUid);
        }
        // 分享入会成功人数加一
        activeRPC.inst.addStaticCounts(param.inviteUid, param.activeId, { inviteJoinPeople: 1 })
    }
} else {
    // 前端说这里返回别的错误码会跳弹窗出来，要返回成功
    return { code: ErrorCode.ok, info: "用户曾注册过会员" }
}
return { code: ErrorCode.ok, info: "入会成功", invitinfo: invF };
```

### 无意义的拼接


