---
title: Interface Problem
date: 2017-10-29 19:13:00 +0800
tags:
- HTTP
---

### 接口中 id 和 Objective-C 中 id 类型冲突

+ iOS 在 Objective-C 中，id 类型是一个独特的数据类型。
+ 不论入参出参都不可以有 id。
+ 接口中不要返回无意义的 id，name 统一加上业务前缀 employeeId / employeeName

### Data 中一定要加上 Key

+ 特别是查询列表数据时，防止添加另一个 key-value 时，Data 数据结构要整体变化。

```json
{
    "code": 0,
    "msg": "success",
    "data": {
        "billNoticeList": [
            {
                "balanceorPayments": "支出",
                "amount": "-2200元",
                "billType": "2",
                "orderNumber": "hx201710110001",
                "transactionNumber": "jx201710110001",
                "transactionTime": "2017-10-11"
            },
            {
                "balanceorPayments": "支出",
                "amount": "-20元",
                "billType": "0",
                "orderNumber": "hx201710110001",
                "transactionNumber": "jx201710110001",
                "transactionTime": "2017-10-11"
            },
            {
                "balanceorPayments": "支出",
                "amount": "-1200元",
                "billType": "1",
                "orderNumber": "hx201710110001",
                "transactionNumber": "jx201710110001",
                "transactionTime": "2017-10-02"
            }
        ],
        "page": {
            "currentPage": 1,
            "perPageInt": 10,
            "startRecord": 0,
            "endRecord": 10,
            "totalRecords": 3,
            "totalPage": 1,
            "linkUrl": "",
            "dataList": []
        }
    }
}
```


