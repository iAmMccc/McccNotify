//
//  ViewController.swift
//  McccNotify
//
//  Created by Mccc on 06/30/2025.
//  Copyright (c) 2025 Mccc. All rights reserved.
//

import UIKit
import McccNotify
import UserNotifications

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().delegate = self
        
        McccNotify.Authorization.request { a, error in
            
        }
        
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        sendNoti1()
//        sendNoti2()
//        sendNoti3()

        
        UNUserNotificationCenter.current().getDeliveredNotifications { notis in
            print("已送达通知：\(notis.map { $0.request.identifier })")
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10) {
            UNUserNotificationCenter.current().getPendingNotificationRequests { pending in
                print("待触发通知：\(pending.map { $0.identifier })")
            }
        }
    }
}


extension ViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // 获取通知标识
        let identifier = response.notification.request.identifier
        print(identifier)
        
        let actionIdentifier = response.actionIdentifier
        print(actionIdentifier)
        
        
        // response.actionIdentifier 是用户触发的动作标识，默认点击通知本体是 UNNotificationDefaultActionIdentifier。
        // 你需要在通知分类（Category）中预先注册这些动作标识。
        
        // 必须调用 completionHandler，告诉系统处理完成
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        McccNotify.Authorization.openSettings()
    }
}


extension ViewController {
    
    func sendNoti1() {
        
        let center = UNUserNotificationCenter.current()

        let content1 = UNMutableNotificationContent()
        content1.title = "每日一句"
        content1.body = "你若盛开，清风自来1111。"
        content1.threadIdentifier = "daily_quotes"
//        content1.interruptionLevel = .passive

        
//        content1.relevanceScore = 0.5
//        content1.interruptionLevel = .timeSensitive

        // 2. 通知触发器（比如10秒后）
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        trigger.nextTriggerDate()

        // 3. 通知请求
        let request = UNNotificationRequest(identifier: "quote_001", content: content1, trigger: nil)

        // 4. 添加通知
        center.add(request) { error in
            if let error = error {
                print("❌ 添加失败：\(error)")
            } else {
                print("✅ 通知已添加")
            }
        }
    }
    
    func sendNoti2() {
        
        let center = UNUserNotificationCenter.current()



        let content2 = UNMutableNotificationContent()
        content2.title = "每日一句"
        content2.body = "生活明朗，万物可爱222。"
        content2.threadIdentifier = "daily_quotes"
        content2.relevanceScore = 0
        content2.interruptionLevel = .timeSensitive

        
        // 2. 通知触发器（比如10秒后）
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        // 3. 通知请求
        let request = UNNotificationRequest(identifier: "quote_002", content: content2, trigger: trigger)

        // 4. 添加通知
        center.add(request) { error in
            if let error = error {
                print("❌ 添加失败：\(error)")
            } else {
                print("✅ 通知已添加")
            }
        }
    }
    
    func sendNoti3() {
        
        let center = UNUserNotificationCenter.current()


        let content3 = UNMutableNotificationContent()
        content3.title = "突发提醒"
        content3.body = "你有新的粉丝"
        content3.threadIdentifier = "alerts"
        content3.relevanceScore = 0.8
        content3.interruptionLevel = .timeSensitive
        // 2. 通知触发器（比如10秒后）
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        // 3. 通知请求
        let request = UNNotificationRequest(identifier: "quote_003", content: content3, trigger: trigger)

        // 4. 添加通知
        center.add(request) { error in
            if let error = error {
                print("❌ 添加失败：\(error)")
            } else {
                print("✅ 通知已添加")
            }
        }
    }
    
    
    func sendNoti() {
        let center = UNUserNotificationCenter.current()
        

        
        /**
         
         内容的附件， 需要加载主bundle中的图片
         图片（如何加载xcassets中的图片），声音，视频，网络下载。
         */
        
        
        // 1. 通知内容
        let content = UNMutableNotificationContent()
        content.title = "📌 每日一句"
        content.body = "每一个不曾起舞的日子，都是对生命的辜负"
//        content.sound = .default
        content.categoryIdentifier = "DAILY_QUOTES"
        content.launchImageName = "LaunchImage"
        content.threadIdentifier = "daily_quotes"

        content.sound = UNNotificationSound(named: UNNotificationSoundName("earlyRiser.m4a"))
//        print(Bundle.main.url(forResource: "earlyRiser", withExtension: "m4a"))

        if let attachment = attachmentFromAsset(named: "头像") {
            content.attachments = [attachment]
        }
        
//        if let imageURL = Bundle.main.url(forResource: "july", withExtension: "mp3") {
//            do {
//                let attachment = try UNNotificationAttachment(identifier: "image", url: imageURL, options: nil)
//                content.attachments = [attachment]
//            } catch {
//                print("附件创建失败：\(error)")
//            }
//        }
//        
        

        // 2. 通知触发器（比如10秒后）
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 4, repeats: false)

        // 3. 通知请求
        let request = UNNotificationRequest(identifier: "quote_001", content: content, trigger: trigger)

        // 4. 添加通知
        center.add(request) { error in
            if let error = error {
                print("❌ 添加失败：\(error)")
            } else {
                print("✅ 通知已添加")
            }
        }
    }
    
    func attachmentFromAsset(named name: String) -> UNNotificationAttachment? {
        guard let image = UIImage(named: name) else {
            print("找不到 asset 图像：\(name)")
            return nil
        }

        // 将 UIImage 转成 PNG 数据
        guard let imageData = image.pngData() else {
            print("图像数据转换失败")
            return nil
        }

        // 写入临时目录
        let tempDir = URL(fileURLWithPath: NSTemporaryDirectory())
        let fileURL = tempDir.appendingPathComponent("\(UUID().uuidString).png")

        do {
            try imageData.write(to: fileURL)
            let attachment = try UNNotificationAttachment(identifier: name, url: fileURL, options: nil)
            return attachment
        } catch {
            print("创建通知附件失败：\(error)")
            return nil
        }
    }

}

