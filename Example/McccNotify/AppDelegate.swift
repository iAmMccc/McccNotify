//
//  AppDelegate.swift
//  McccNotify
//
//  Created by Mccc on 06/30/2025.
//  Copyright (c) 2025 Mccc. All rights reserved.
//

import UIKit
import UserNotifications
import BackgroundTasks

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.myapp.cleanup", using: nil) { task in
            self.handleCleanupTask(task: task as! BGProcessingTask)
        }
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        scheduleCleanupTask()
    }
    
    func scheduleCleanupTask() {
        let request = BGProcessingTaskRequest(identifier: "com.myapp.cleanup")
        request.requiresNetworkConnectivity = false
        request.requiresExternalPower = false
        request.earliestBeginDate = Date(timeIntervalSinceNow: 5) // 15 分钟后
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("提交后台任务失败：\(error)")
        }
    }
    
    func handleCleanupTask(task: BGProcessingTask) {
        task.expirationHandler = {
            // 超时处理
        }

        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            let content = UNMutableNotificationContent()
            content.title = "🧹 清理完成"
            content.body = "成功释放 240MB 空间"
            content.sound = .default

            let request = UNNotificationRequest(identifier: "cleanup_complete", content: content, trigger: nil)
            UNUserNotificationCenter.current().add(request)

            task.setTaskCompleted(success: true)

            // 任务结束后重新调度下一次任务（如果需要持续执行）
            self.scheduleCleanupTask()
        }
    }
}
