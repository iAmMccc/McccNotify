//
//  NotificationService.swift
//  NotificationService
//
//  Created by qixin on 2025/7/17.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import UserNotifications
import McccNotify

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {

        
        print("执行了通知的扩展")
        
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        guard let content = bestAttemptContent else {
            contentHandler(request.content)
            return
        }
                
        guard let url = McccNotifyAttachment.identifyResource(from: content.userInfo)?.getUrl() else {
            contentHandler(request.content)
            return
        }
        
        McccNotifyAttachment
            .downloadAttachment(from: url) { result in
                switch result {
                case .success(let attachment):
                    content.attachments = [attachment]
                    contentHandler(content)
                case .failure(let failure):
                    print(failure)
                    contentHandler(request.content)
                }
            }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
}

