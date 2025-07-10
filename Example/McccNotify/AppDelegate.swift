//
//  AppDelegate.swift
//  McccNotify
//
//  Created by Mccc on 06/30/2025.
//  Copyright (c) 2025 Mccc. All rights reserved.
//

import UIKit
import UserNotifications
import McccNotify

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        
        McccNotify.enableLogging()
        
        notifyAuthorization()
        setMcccNotifyDelegate()
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        McccNotify.applicationDidBecomeActive()
    }
}


extension AppDelegate {
    func notifyAuthorization() {
        McccNotify.Authorization.request(options: [.alert, .sound, .badge, .criticalAlert]) { granted, error in
//            print(granted ? "同意通知授权" : "拒绝了通知授权")
        }
    }
    
    func setMcccNotifyDelegate() {
        let notify = McccNotifyDelegateHandler.standard
        notify.onWillPresent = { notification in
            [.banner, .sound]
        }
        
        notify.onReceiveResponse = { response in
            print("收到通知点击: \(response)")
            
            print("携带的信息：\(response.notification.request.content.userInfo)")
            
            let actionIdentifier = response.actionIdentifier
            if !actionIdentifier.isEmpty {
                print("actionId = \(actionIdentifier)")
            }
        }
        
        notify.onOpenSettings = { notification in
            print("notification")
        }
    }
}


/**
 <key>NSExtensionAttributes</key>
 <dict>
    <!-- 关键通知权限声明 -->
    <key>UNNotificationExtensionCriticalAlert</key>
    <true/>
 <dict>
 */
