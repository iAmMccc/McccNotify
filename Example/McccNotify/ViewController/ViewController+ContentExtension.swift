//
//  ViewController+ContentExtension.swift
//  McccNotify_Example
//
//  Created by qixin on 2025/7/9.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import Foundation
import McccNotify

extension ViewController {
    var notify_contentExtension: [String: Any] {
        [
            "title": "通知内容扩展测试",
            "list": [
                ["name": "通知扩展 - 支持点击闹钟"],
                ["name": "通知扩展 - 带交互按钮"],
            ]
        ]
    }
    
    func didSelectSection7(atRow row: Int) {
        switch row {
        case 0:
            McccNotify()
                .content {
                    $0.title("通知标题")
                    $0.body("测试通知的内容扩展【下拉查看】")
                    $0.normalSound()
                }
                .category(id: "dailyQuotes")
                .trigger(.timeInterval(4, repeats: false))
                .send()
        case 1:
            McccNotify()
                .content {
                    $0.title("通知标题")
                    $0.body("测试通知的内容扩展【下拉查看】")
                    $0.normalSound()
                }
                .category(id: "dailyQuotes") {
                    $0.action("close", title: "关闭闹钟")
                }
                .trigger(.timeInterval(4, repeats: false))
                .send()
        default:
            break
        }
    }
}
