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
        print("执行了Service的didReceive")

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
    
    
    private func downloadAndAttach(from url: URL,
                                       options: [String: Any] = [:],
                                       completion: @escaping (UNNotificationContent) -> Void) {
            let session = URLSession(configuration: .default)
            let task = session.downloadTask(with: url) { localURL, _, error in
                guard let localURL = localURL else {
                    print("附件下载失败：\(error?.localizedDescription ?? "未知错误")")
                    completion(self.bestAttemptContent ?? UNNotificationContent())
                    return
                }
                
                let fileManager = FileManager.default
                let tmpDir = URL(fileURLWithPath: NSTemporaryDirectory())
                let tmpFile = tmpDir.appendingPathComponent(url.lastPathComponent)
                
                do {
                    if fileManager.fileExists(atPath: tmpFile.path) {
                        try fileManager.removeItem(at: tmpFile)
                    }
                    try fileManager.moveItem(at: localURL, to: tmpFile)
                    
                    let attachment = try UNNotificationAttachment(identifier: UUID().uuidString,
                                                                  url: tmpFile,
                                                                  options: options)
                    self.bestAttemptContent?.attachments = [attachment]
                } catch {
                    print("附件处理失败：\(error.localizedDescription)")
                }
                
                completion(self.bestAttemptContent ?? UNNotificationContent())
            }
            task.resume()
        }

}

