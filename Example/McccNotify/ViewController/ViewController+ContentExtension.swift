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
                ["name": "展示基本文本内容"],
                ["name": "带图片附件的通知展示"],
                ["name": "带交互按钮的通知"],
                ["name": "带文本输入按钮的通知"],
                ["name": "动态更新通知内容"],
                ["name": "模拟用户点击操作回调"]
            ]
        ]
    }
    
    func didSelectSection7(atRow row: Int) {
        switch row {
        case 0:
            McccNotify()
                .content {
                    $0.title("通知标题")
                    $0.body("测试通知的内容扩展")
                    $0.normalSound()
                }
                .category(id: "dailyQuotes")
                .trigger(.timeInterval(4, repeats: false))
                .send()
            // 构造简单通知，调用ContentExtension的didReceive方法，断言UI显示正确
        case 1:
            break
            // 构造带图片附件的通知，调用didReceive，校验图片显示
        case 2:
            break
            // 构造带按钮的通知，校验按钮渲染
        case 3:
            break
            // 构造带文本输入按钮的通知
        case 4:
            break
            // 模拟连续调用didReceive，校验UI刷新
        case 5:
            break
            // 模拟点击按钮回调didReceive(_:completionHandler:)的处理
        default:
            break
        }
    }
}
