# McccNotify

一款基于 `UserNotifications` 框架的 Swift 轻量级通知库，支持本地通知的全方位功能封装，包括：

- 通知权限申请与状态检测
- 多种触发器支持（时间、日历、地理位置）
- 富媒体附件（图片、音频、视频）
- 关键通知、铃声通知、自定义声音
- 通知类别（Category）和交互按钮
- 通知内容扩展支持
- 待发送和已送达通知的查询和管理
- 统一链式调用设计，使用简单灵活



## 安装

`pod 'McccNotify'`



## 快速开始

### 请求通知权限

```
McccNotify.Authorization.request { granted, error in
    print("通知权限：\(granted), 错误：\(error?.localizedDescription ?? "无")")
}
```

### 发送一条本地通知

```
McccNotify()
    .content {
        $0.title("通知标题")
        $0.body("这是通知的正文内容")
    }
    .trigger(.timeInterval(5))  // 5秒后触发
    .send()
```



## 主要功能示例

### 通知权限管理

- 请求权限
- 获取当前授权状态
- 检查关键通知是否开启
- 跳转系统通知设置页面

### 通知内容配置

- 标题、副标题、正文、角标、用户信息
- 附件（图片、音频、视频）
- 中断等级、相关性评分、过滤标签

### 通知声音

- 普通通知声音（默认/自定义）
- 铃声通知声音（iOS 15.2+，默认/自定义）
- 关键通知声音（Critical Alert，需特殊权限）

### 通知类别（Category）

- 添加多个操作按钮
- 支持文本输入按钮
- 混合按钮与输入框

### 通知触发器

- 时间间隔触发
- 日历时间触发（可重复）
- 地理位置进入/离开触发

### 通知请求管理

- 查询所有待发送通知
- 查询所有已送达通知
- 删除指定或全部通知

## 示例代码

```
// 发送带图片附件的通知
let attachments = McccNotifyAttachment()
    .addAssetImage(named: "avatar")
    .build()

McccNotify()
    .content {
        $0.title("带附件的通知")
        $0.body("这是一条带图片附件的通知")
        $0.attachments(attachments)
    }
    .trigger(.timeInterval(10))
    .send()

// 发送带按钮交互的通知
McccNotify()
    .content {
        $0.title("操作通知")
        $0.body("带有发送和删除按钮")
    }
    .category(id: "actionCategory") {
        $0.action("send", title: "发送")
        $0.action("delete", title: "删除", options: [.destructive])
    }
    .trigger(.timeInterval(5))
    .send()
```

## 通知代理（Delegate）

McccNotify 支持通过代理回调监听通知的展示和用户交互事件。你可以通过设置 `McccNotifyDelegateHandler.standard` 来统一处理通知回调。

### 设置代理示例

```
func setMcccNotifyDelegate() {
    let notify = McccNotifyDelegateHandler.standard
    
    // 前台收到通知时调用，返回展示方式（横幅、声音、徽章等）
    notify.onWillPresent = { notification in
        print("前台收到通知: \(notification.request.identifier)")
        return [.banner, .sound]
    }
    
    // 用户点击通知或按钮时调用
    notify.onReceiveResponse = { response in
        print("收到通知点击: \(response)")
        print("携带的信息：\(response.notification.request.content.userInfo)")
        
        let actionIdentifier = response.actionIdentifier
        if actionIdentifier != UNNotificationDefaultActionIdentifier &&
           actionIdentifier != UNNotificationDismissActionIdentifier {
            print("用户点击了自定义按钮 actionId = \(actionIdentifier)")
            // 根据 actionId 处理不同按钮事件
        } else if actionIdentifier == UNNotificationDefaultActionIdentifier {
            print("用户点击了通知本体，进入应用")
        } else if actionIdentifier == UNNotificationDismissActionIdentifier {
            print("用户关闭了通知")
        }
    }
    
    // 用户点击系统设置按钮（iOS 15+）
    notify.onOpenSettings = { notification in
        print("用户点击了通知设置按钮，通知ID: \(notification.request.identifier)")
        // 可在此引导用户操作或统计
    }
}
```

### 说明

- `onWillPresent`：通知在应用前台弹出时触发。必须返回 `UNNotificationPresentationOptions`，告诉系统如何展示通知。
- `onReceiveResponse`：用户点击通知或者通知内交互按钮后触发。可根据 `actionIdentifier` 区分不同按钮操作。
- `onOpenSettings`：用户点击通知弹窗“设置”按钮时触发，仅支持 iOS 15 及以上。
- 设置完成后，McccNotifyDelegateHandler 会代理系统通知中心，接管通知事件。



## 注意事项

- 关键通知（Critical Alert）需要在 Info.plist 中配置 `UIBackgroundModes` 包含 `critical-alert`，并且用户必须授权关键通知权限。
- 地理位置触发需要用户授权定位权限且 App 允许后台定位。
- 每个 App 最多注册 20 个地理围栏通知。
- 自定义声音文件必须包含在 App Bundle 中，且格式支持系统要求。
- 通知附件文件大小有限制（苹果文档有说明），避免过大导致通知无法正常显示。
- 请合理使用通知权限请求，避免反复弹窗导致用户拒绝。



## 贡献

欢迎提 Issue 或 Pull Request，一起完善功能。
