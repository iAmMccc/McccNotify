//
//  McccNotifyDelegateHandler.swift
//  McccNotify
//
//  Created by qixin on 2025/7/8.
//

import Foundation


public final class McccNotifyDelegateHandler: NSObject {

    public static let standard = McccNotifyDelegateHandler()

    private override init() {
        super.init()
    }

    private var hasSetDelegate = false
    private func checkAndSetDelegate() {
        guard !hasSetDelegate else { return }
        UNUserNotificationCenter.current().delegate = self
        hasSetDelegate = true
    }

    private var _onReceiveResponse: ((UNNotificationResponse, @escaping () -> Void) -> Void)?
    public var onReceiveResponse: ((UNNotificationResponse, @escaping () -> Void) -> Void)? {
        get { _onReceiveResponse }
        set {
            _onReceiveResponse = newValue
            if newValue != nil {
                checkAndSetDelegate()
            }
        }
    }

    private var _onWillPresent: ((UNNotification) -> UNNotificationPresentationOptions)?
    public var onWillPresent: ((UNNotification) -> UNNotificationPresentationOptions)? {
        get { _onWillPresent }
        set {
            _onWillPresent = newValue
            if newValue != nil {
                checkAndSetDelegate()
            }
        }
    }
    
    private var _onOpenSettings: ((UNNotification?) -> Void)?
    public var onOpenSettings: ((UNNotification?) -> Void)? {
        get { _onOpenSettings }
        set {
            _onOpenSettings = newValue
            if newValue != nil {
                checkAndSetDelegate()
            }
        }
    }

}

// MARK: - UNUserNotificationCenterDelegate

extension McccNotifyDelegateHandler: UNUserNotificationCenterDelegate {

    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if let handler = onWillPresent {
            completionHandler(handler(notification))
        } else {
            completionHandler([.banner, .sound])
        }
    }

    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       didReceive response: UNNotificationResponse,
                                       withCompletionHandler completionHandler: @escaping () -> Void) {
        onReceiveResponse?(response, completionHandler)
        completionHandler()
    }

    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       openSettingsFor notification: UNNotification?) {
        if let handler = onOpenSettings {
            handler(notification)
        }
    }
}
