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
                ["name": "发送带标题和正文的通知"],
                ["name": "发送带 subtitle 的通知"],
                ["name": "发送带 threadIdentifier 的通知（通知分组）"],
                ["name": "发送带 categoryIdentifier 的通知（用于交互）"]
            ]
        ]
    }
    
    
    func didSelectSection2(atRow row: Int) {
        switch row {
        case 0:
           break
            
        case 1:
            break
            
        case 2:
            break
            
        case 3:
            break
            
        default:
            break
        }
    }
}
