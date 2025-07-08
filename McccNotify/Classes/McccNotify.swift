//
//  McccNotify.swift
//  McccNotify
//
//  Created by qixin on 2025/7/1.
//

import Foundation
import UIKit

import UserNotifications
import UIKit

public final class McccNotify {
    private var identifier: String = UUID().uuidString
    private var categoryId: String?
    private var threadId: String?
    private var contentBuilder = ContentBuilder()
    private var trigger: UNNotificationTrigger?

    public init() {}
}


// MARK: 标识符设置
extension McccNotify {
    
    /// 设置通知请求的 ID，用于撤销或更新通知
    @discardableResult
    public func requestIdentifier(_ id: String) -> Self {
        self.identifier = id
        return self
    }

    /// 设置通知内容的分类 ID，用于绑定按钮/交互定义
    @discardableResult
    public func categoryIdentifier(_ id: String) -> Self {
        self.categoryId = id
        return self
    }

    /// 设置通知的线程 ID，用于通知分组展示
    @discardableResult
    public func threadIdentifier(_ id: String) -> Self {
        self.threadId = id
        return self
    }
}

// MARK: - 内容构造
extension McccNotify {
    @discardableResult
    public func content(_ config: (ContentBuilder) -> Void) -> Self {
        config(contentBuilder)
        return self
    }
}

// MARK: - 触发器设置
extension McccNotify {

    /// 设置触发器
    @discardableResult
    public func trigger(_ trigger: Trigger) -> Self {
        self.trigger = trigger.toUNNotificationTrigger()
        return self
    }

}

// MARK: 发出请求
extension McccNotify {

    public func send() {
        let content = contentBuilder.build()

        if let cat = categoryId {
            content.categoryIdentifier = cat
        }
        if let thread = threadId {
            content.threadIdentifier = thread
        }

        let finalTrigger = trigger ?? UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: finalTrigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
