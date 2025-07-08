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
       
        notifyAuthorization()
        setMcccNotifyDelegate()
        return true
    }
}


extension AppDelegate {
    func notifyAuthorization() {
        McccNotify.Authorization.request(options: [.alert, .sound, .badge, .criticalAlert]) { granted, error in
            print(granted ? "同意通知授权" : "拒绝了通知授权")
        }
    }
    
    func setMcccNotifyDelegate() {
        let notify = McccNotifyDelegateHandler.standard
        notify.onWillPresent = { notification in
            [.banner, .sound]
        }
        
        notify.onReceiveResponse = { response in
            print("收到通知点击: \(response.actionIdentifier)")
        }
        
        notify.onOpenSettings = { notification in
            print("notification")
        }
    }
}
