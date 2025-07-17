//
//  McccNotify.swift
//  McccNotify
//
//  Created by qixin on 2025/7/1.
//

import Foundation
import UIKit
import UserNotifications

public final class McccNotify {
    private var contentBuilder = ContentBuilder()
    private var categoryBuilder: CategoryBuilder?
    private var trigger: UNNotificationTrigger?
    public init() {}
}



extension McccNotify {
    /// 启用 McccNotify 的调试日志功能。
    public static func enableLogging() {
        NotifyLogger.isEnabled = true
    }
    
    /// 关闭 McccNotify 的调试日志功能。
    public static func disableLogging() {
        NotifyLogger.isEnabled = false
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


// MARK: - 分类构造
extension McccNotify {
    @discardableResult
    public func category(id: String, _ config: ((CategoryBuilder) -> Void)? = nil) -> Self {

        if categoryBuilder == nil {
            categoryBuilder = CategoryBuilder()
        }
        
        categoryBuilder?.categoryIdentifier = id
        if let builder = categoryBuilder, let config = config {
            config(builder)
        }
        return self
    }
}


// MARK: 发出请求
extension McccNotify {

    public func send(requestIdentifier: String = UUID().uuidString) {
        let content = contentBuilder.build()

        if let category = categoryBuilder {
            content.categoryIdentifier = category.categoryIdentifier
            category.register()
        }

        let finalTrigger = trigger ?? UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: finalTrigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}


extension McccNotify {
    
    public static func applicationDidBecomeActive() {
        BadgeManager.shared.applicationDidBecomeActive()
    }
}
