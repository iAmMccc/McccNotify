//
//  ViewController+Trigger.swift
//  McccNotify_Example
//
//  Created by qixin on 2025/7/9.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import Foundation
import McccNotify
import CoreLocation

extension ViewController {
    var notify_trigger: [String: Any] {
        [
            "title": "通知触发器测试",
            "list": [
                ["name": "立即触发的通知"],
                ["name": "延时 5 秒的通知"],
                ["name": "日历时间触发（当前日历时间的下一分钟）"],
                ["name": "位置进入通知（模拟位置）"],
                ["name": "位置离开通知（模拟位置）"]
            ]
        ]
    }

    func didSelectSection4(atRow row: Int) {
        switch row {
        case 0:
            // 立即触发
            McccNotify()
                .content {
                    $0.title("通知标题", subTitle: "这是副标题")
                    $0.body("这是通知主内容")
                }
                .trigger(.timeInterval(0, repeats: false))
                .send()

        case 1:
            // 延时 5 秒
            McccNotify()
                .content {
                    $0.title("5 秒后通知")
                    $0.body("请等待 5 秒后查看通知")
                }
                .trigger(.timeInterval(5, repeats: false))
                .send()

        case 2:
            
            let now = Calendar.current.dateComponents([.hour, .minute], from: Date())
            var components = DateComponents()
            components.hour = now.hour
            components.minute = (now.minute ?? 0) + 1 // 下一分钟触发

            McccNotify()
                .content {
                    $0.title("每日 9 点提醒")
                    $0.body("这是一个基于日历的通知触发器")
                }
                .trigger(.calendar(components, repeats: true))
                .send()
            
        case 3:
            

            // 模拟位置进入触发
            let center = CLLocationCoordinate2D(latitude: 31.309343373431233, longitude: 120.77554226674485) // 2.5产业园

            McccNotify()
                .content {
                    $0.title("进入指定位置")
                    $0.body("你刚进入了指定区域")
                }
                .trigger(.locationOnEntry(center: center, radius: 100, identifier: "进入上海市中心", repeats: true))
                .send()

        case 4:
            // 模拟位置离开触发
            let center = CLLocationCoordinate2D(latitude: 31.309343373431233, longitude: 120.77554226674485) // 2.5产业园

            McccNotify()
                .content {
                    $0.title("进入指定位置")
                    $0.body("你刚进入了指定区域")
                }
                .trigger(.locationOnExit(center: center, radius: 100, identifier: "进入上海市中心", repeats: true))
                .send()

        default:
            break
        }
    }
}
