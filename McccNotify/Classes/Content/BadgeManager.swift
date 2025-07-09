//
//  BadgeManager.swift
//  McccNotify
//
//  Created by qixin on 2025/7/8.
//

import Foundation


final class BadgeManager {
    static let shared = BadgeManager()
    private init() {}

    private let badgeKey = "BadgeManager.currentBadge"

    /// 当前 badge 值
    var currentBadge: Int {
        get { UserDefaults.standard.integer(forKey: badgeKey) }
        set {
            UserDefaults.standard.set(newValue, forKey: badgeKey)
            updateSystemBadge(to: newValue)
        }
    }

    /// 增加 badge 值
    func increase(by value: Int = 1) {
        currentBadge += value
    }

    /// 设置 badge 值
    func set(_ value: Int) {
        currentBadge = value
    }

    /// 清除 badge 值（应用角标 & 存储）
    func clear() {
        currentBadge = 0
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }

    /// 点击图标或进入前台时可调用
    func applicationDidBecomeActive() {
        clear()
    }

    /// 实际设置 App 图标上的角标数字
    private func updateSystemBadge(to value: Int) {
        DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber = value
        }
    }
}
