//
//  ViewController+Sound.swift
//  McccNotify_Example
//
//  Created by qixin on 2025/7/9.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import Foundation
import McccNotify
import CoreLocation

extension ViewController {
    var notify_sound: [String: Any] {
        [
            "title": "通知声音",
            "list": [
                ["name": "普通声音 - 默认声音"],
                ["name": "普通声音 - 自定义声音"],
                
                ["name": "铃声声音 - 默认声音"],
                ["name": "铃声声音 - 自定义声音"],
                
                ["name": "关键声音 - 默认声音"],
                ["name": "关键声音 - 自定义声音"],
            ]
        ]
    }

    func didSelectSection5(atRow row: Int) {
        switch row {
        case 0:
           
            McccNotify()
                .content {
                    $0.title("通知标题")
                    $0.body("测试声音")
                    $0.normalSound()
                }
                .trigger(.timeInterval(4, repeats: false))
                .send()

        case 1:
            McccNotify()
                .content {
                    $0.title("通知标题")
                    $0.body("测试声音")
                    $0.normalSound("july.mp3")
                }
                .trigger(.timeInterval(4, repeats: false))
                .send()

        case 2:
            
            McccNotify()
                .content {
                    $0.title("通知标题")
                    $0.body("测试声音")
                    $0.ringtoneSound()
                }
                .trigger(.timeInterval(4, repeats: false))
                .send()
            
        case 3:
            McccNotify()
                .content {
                    $0.title("通知标题")
                    $0.body("测试声音")
                    $0.ringtoneSound("july.mp3")
                }
                .trigger(.timeInterval(4, repeats: false))
                .send()

        case 4:
            McccNotify()
                .content {
                    $0.title("通知标题")
                    $0.body("测试声音")
                    $0.criticalSound()
                }
                .trigger(.timeInterval(4, repeats: false))
                .send()
            
        case 5:
            McccNotify()
                .content {
                    $0.title("通知标题")
                    $0.body("测试声音")
                    $0.criticalSound(soundName: "july.mp3", volume: 1)
                }
                .trigger(.timeInterval(4, repeats: false))
                .send()

        default:
            break
        }
    }
}
