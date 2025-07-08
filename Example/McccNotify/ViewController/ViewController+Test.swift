//
//  ViewController+Test.swift
//  McccNotify_Example
//
//  Created by qixin on 2025/7/8.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import Foundation
import McccNotify

extension ViewController {
    var notify_test: [String: Any] {
        [
            "title": "基础测试",
            "list": [
                ["name": "发送一个普通通知"],
            ]
        ]
    }
    
    
    func didSelectSection0(atRow row: Int) {
        
        McccNotify()
            .requestIdentifier("123")
            .content {
                $0.title("通知标题")
                $0.body("这是副标题")
            }
            .trigger(.timeInterval(5, repeats: false))
            .send()
    }
}
