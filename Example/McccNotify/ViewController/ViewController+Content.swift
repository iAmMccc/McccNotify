//
//  ViewController+Content.swift
//  McccNotify_Example
//
//  Created by qixin on 2025/7/8.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import Foundation
import McccNotify

extension ViewController {
    var notify_content: [String: Any] {
        [
            "title": "通知内容测试",
            "list": [
                ["name": "通知内容 - 文本内容"],
                ["name": "通知内容 - 角标管理"],
                ["name": "通知内容 - 图片附件"],
                ["name": "通知内容 - 音频附件"],
                ["name": "通知内容 - 视频附件"],
                ["name": "通知内容 - 通知分组"],
                ["name": "通知内容 - 携带信息"],

            ]
        ]
    }
    
    
    func didSelectSection3(atRow row: Int) {
        switch row {
        case 0:
            McccNotify()
                .content {
                    $0.title("通知标题", subTitle: "这是副标题")
                    $0.body("这是通知主内容")
                }
                .trigger(.timeInterval(4, repeats: false))
                .send()
         case 1:
            McccNotify()
                .content {
                    $0.title("通知标题")
                    $0.body("这是通知主内容")
                    $0.badge(100)
                }
                .trigger(.timeInterval(4, repeats: false))
                .send()
            
        case 2:
            
            let attachments = McccNotifyAttachment()
                .addAssetImage(named: "头像")
                .build()
            
            
            McccNotify()
                .content {
                    $0.title("通知标题")
                    $0.body("这是通知主内容")
                    $0.attachments(attachments)
                }
                .trigger(.timeInterval(4, repeats: false))
                .send()
            
        case 3:
            let attachments = McccNotifyAttachment()
                .addFile(named: "july", withExtension: "mp3")
                .build()
            
            
            McccNotify()
                .content {
                    $0.title("通知标题")
                    $0.body("这是通知主内容")
                    $0.attachments(attachments)
                }
                .trigger(.timeInterval(4, repeats: false))
                .send()
            
        case 4:
            let attachments = McccNotifyAttachment()
                .addFile(named: "loading", withExtension: "mov")
                .build()
            
            
            McccNotify()
                .content {
                    $0.title("通知标题")
                    $0.body("这是通知主内容")
                    $0.attachments(attachments)
                }
                .trigger(.timeInterval(4, repeats: false))
                .send()
            
        case 5:
            // 需要在锁屏中查看
            McccNotify()
                .content {
                    $0.title("通知标题")
                    $0.body("这是通知主内容")
                    $0.threadIdentifier("groupNotify")
                }
                .trigger(.timeInterval(4, repeats: false))
                .send()
            
            McccNotify()
                .content {
                    $0.title("通知标题2")
                    $0.body("这是通知主内容2")
                    $0.threadIdentifier("groupNotify")
                }
                .trigger(.timeInterval(4, repeats: false))
                .send()
            
        case 6:
            
            // 在onReceiveResponse中的response.notification.request.content.userInfo查看。
            McccNotify()
                .content {
                    $0.title("通知标题", subTitle: "这是副标题")
                    $0.body("这是通知主内容")
                    $0.userInfo(["url": "setting"])
                }
                .trigger(.timeInterval(4, repeats: false))
                .send()
        default:
            break
        }
    }
}
