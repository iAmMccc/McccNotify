//
//  ViewController+Management.swift
//  McccNotify_Example
//
//  Created by qixin on 2025/7/8.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import Foundation
import McccNotify

extension ViewController {
    
    var notify_management: [String: Any] {
        [
            "title": "通知请求管理",
            "list": [
                ["name": "待发送通知 - 查询所有"],
                ["name": "待发送通知 - 查询某些"],
                ["name": "待发送通知 - 删除所有"],
                ["name": "待发送通知 - 删除指定"],
                
                ["name": "已送达通知 - 查询所有"],
                ["name": "已送达通知 - 查询某些"],
                ["name": "已送达通知 - 删除所有"],
                ["name": "已送达通知 - 删除指定"],
            ]
        ]
    }
    
    func didSelectSection2(atRow row: Int) {
        switch row {
            // 待发送通知（Pending）
        case 0:
            McccNotify.Request.getPending { requests in
                print("所有待发送通知：\(requests.map(\.identifier))")
            }
        case 1:
            McccNotify.Request.hasPending(id: "test_pending") { exists in
                print("是否存在待发送通知 'test_pending'：\(exists)")
            }
        case 2:
            McccNotify.Request.removeAllPending()
            print("已删除所有待发送通知")
        case 3:
            McccNotify.Request.removePending(ids: ["test_pending"])
            print("删除待发送通知 id = test_pending")
            
            // 已送达通知（Delivered）
        case 4:
            McccNotify.Request.getDelivered { delivered in
                print("所有已送达通知：\(delivered.map { $0.request.identifier })")
            }
        case 5:
            McccNotify.Request.hasDelivered(id: "test_delivered") { exists in
                print("是否存在已送达通知 'test_delivered'：\(exists)")
            }
        case 6:
            McccNotify.Request.removeAllDelivered()
            print("已删除所有已送达通知")
        case 7:
            McccNotify.Request.removeDelivered(ids: ["test_delivered"])
            print("删除已送达通知 id = test_delivered")
            
        default:
            break
        }
    }
    
}
