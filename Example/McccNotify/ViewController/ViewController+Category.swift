//
//  ViewController+Category.swift
//  McccNotify_Example
//
//  Created by qixin on 2025/7/9.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import Foundation
import McccNotify


extension ViewController {
    var notify_category: [String: Any] {
        [
            "title": "通知类别（Category）测试",
            "list": [
                ["name": "带两个按钮的通知"],
                ["name": "带输入框的通知"],
                ["name": "按钮 + 输入混合交互"]
            ]
        ]
    }

    func didSelectSection6(atRow row: Int) {
        switch row {
        case 0:
                       
            McccNotify()
                .content {
                    $0.title("通知标题")
                    $0.body("测试按钮action")
                    $0.normalSound()
                }
                .category(id: "actionId") {
                    $0.action("send", title: "发送")
                    $0.action("delete", title: "删除", options: [.destructive])
                }
                .trigger(.timeInterval(4, repeats: false))
                .send()

        case 1:
            McccNotify()
                .content {
                    $0.title("通知标题")
                    $0.body("测试输入action")
                }
                .category(id: "inputId") {
                    $0.textInput("input", title: "输入按钮", sendTitle: "发送")
                }
                .trigger(.timeInterval(4, repeats: false))
                .send()

        case 2:
            
            McccNotify()
                .content {
                    $0.title("通知标题")
                    $0.body("测试按钮action")
                    $0.normalSound()
                }
                .category(id: "fixId") {
                    $0.action("send", title: "发送")
                    $0.textInput("input", title: "输入按钮", sendTitle: "发送")
                }
                .trigger(.timeInterval(4, repeats: false))
                .send()

        default:
            break
        }
    }
}
