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
        
        notifyAuthorization(application: application)
        setMcccNotifyDelegate()
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        McccNotify.applicationDidBecomeActive()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // deviceToken 是二进制数据，需要转成字符串
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        
        // 这里可以把 token 发送给你自己的服务器，方便服务器推送
    }

    // 注册失败
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
}


extension AppDelegate {
    func notifyAuthorization(application: UIApplication) {
        McccNotify.Authorization.request(options: [.alert, .sound, .badge, .criticalAlert]) { granted, error in
            application.registerForRemoteNotifications()
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
