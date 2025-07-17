//
//  CategoryBuilder.swift
//  McccNotify
//
//  Created by qixin on 2025/7/9.
//

import Foundation
import UserNotifications


extension McccNotify {
    public final class CategoryBuilder {
        private var actions: [UNNotificationAction] = []
        private var options: UNNotificationCategoryOptions = []
        var categoryIdentifier: String = ""

        public init() {}

        /// 添加一个操作按钮
        public func action(_ id: String, title: String, options: UNNotificationActionOptions = []) {
            let action = UNNotificationAction(identifier: id, title: title, options: options)
            actions.append(action)
        }

        /// 添加一个文本输入按钮
        public func textInput(_ id: String, title: String, placeholder: String = "", sendTitle: String, options: UNNotificationActionOptions = []) {
            let action = UNTextInputNotificationAction(identifier: id, title: title, options: options, textInputButtonTitle: sendTitle, textInputPlaceholder: placeholder)
            actions.append(action)
        }


        /// 设置额外选项（如 customDismissAction）
        public func options(_ options: UNNotificationCategoryOptions) {
            self.options = options
        }
    }
}

extension McccNotify.CategoryBuilder {
    /// 注册 Category 到通知中心
    func register() {
        guard !categoryIdentifier.isEmpty else {
            NotifyLogger.log(level: .error, module: .category, message: "categoryIdentifier不可为空")
            return
        }
        let category = UNNotificationCategory(
            identifier: categoryIdentifier,
            actions: actions,
            intentIdentifiers: [],
            options: options
        )
        
        UNUserNotificationCenter.current().getNotificationCategories { existing in
            // 先移除旧的 Category，再插入新的
            var all = existing.filter { $0.identifier != category.identifier }
            all.insert(category)
            UNUserNotificationCenter.current().setNotificationCategories(all)
        }
    }
}
