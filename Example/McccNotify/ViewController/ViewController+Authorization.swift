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
    var notify_authorization: [String: Any] {
        [
            "title": "通知权限测试",
            "list": [
                ["name": "请求通知权限"],
                ["name": "检查是否开启通知权限"],
                ["name": "检查是否开启关键通知权限"],
                ["name": "跳转到系统通知设置"]
            ]
        ]
    }
    
    
    func didSelectSection1(atRow row: Int) {
        switch row {
        case 0:
            McccNotify.Authorization.request { granted, error in
                print("请求权限：\(granted), error: \(error?.localizedDescription ?? "无")")
            }
            
        case 1:
            McccNotify.Authorization.getStatus { status in
                print("当前通知权限状态：\(status.rawValue)")
            }
            
        case 2:
            McccNotify.Authorization.isCriticalAlertEnabled { enabled in
                print("关键通知是否开启：\(enabled)")
            }
            
        case 3:
            McccNotify.Authorization.openSettings()
            
        default:
            break
        }
    }
}
