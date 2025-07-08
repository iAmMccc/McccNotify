//
//  Category.swift
//  McccNotify
//
//  Created by qixin on 2025/7/8.
//

import Foundation
import UserNotifications


extension McccNotify {
    public final class Category {
        private var _identifier: String = ""
        private var _actions: [UNNotificationAction] = []

        public init() {}

        @discardableResult
        public func identifier(_ id: String) -> Self {
            self._identifier = id
            return self
        }

        @discardableResult
        public func actions(_ items: [UNNotificationAction]) -> Self {
            self._actions = items
            return self
        }

        @discardableResult
        public func register(options: UNNotificationCategoryOptions = []) -> Self {
            guard !_identifier.isEmpty else {
                print("⚠️ Notification category identifier is empty.")
                return self
            }

            let category = UNNotificationCategory(
                identifier: _identifier,
                actions: _actions,
                intentIdentifiers: [],
                options: options
            )
            UNUserNotificationCenter.current().setNotificationCategories([category])
            return self
        }
    }
}
