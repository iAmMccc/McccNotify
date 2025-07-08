//
//  ViewController.swift
//  McccNotify
//
//  Created by Mccc on 06/30/2025.
//  Copyright (c) 2025 Mccc. All rights reserved.
//

import UIKit
import McccNotify
import UserNotifications


class ViewController: UIViewController {
    
    
    var dataArray: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "通知详解"

        dataArray = [
            notify_test,
            notify_authorization,
            notify_content,
            notify_trigger,
            notify_sound,
            notify_category,
            notify_attachment
        ]
        
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.reloadData()
    }
    
    lazy var tableView = UITableView.make(registerCells: [UITableViewCell.self], delegate: self, style: .grouped)
}


extension ViewController {
    

    var notify_trigger: [String: Any] {
        [
            "title": "通知触发器测试",
            "list": [
                ["name": "立即触发的通知"],
                ["name": "延时 5 秒的通知"],
                ["name": "日历时间触发（每天 9:00）"],
                ["name": "位置进入通知（模拟位置）"],
                ["name": "位置离开通知（模拟位置）"]
            ]
        ]
    }
    
    var notify_sound: [String: Any] {
        [
            "title": "通知声音测试",
            "list": [
                ["name": "系统默认声音"],
                ["name": "自定义声音文件"],
                ["name": "关键通知声音（需授权）"],
                ["name": "铃声类型声音（iOS 15.2+）"],
                ["name": "自动判断是否支持关键通知，降级播放"]
            ]
        ]
    }
    
    var notify_category: [String: Any] {
        [
            "title": "通知交互（Category）测试",
            "list": [
                ["name": "注册带按钮的通知类别"],
                ["name": "发送一个带交互按钮的通知"],
                ["name": "处理通知按钮点击响应"],
                ["name": "发送一个带文本输入按钮的通知"]
            ]
        ]
    }
    
    var notify_attachment: [String: Any] {
        [
            "title": "通知附件测试",
            "list": [
                ["name": "发送带图片附件的通知"],
                ["name": "发送带音频附件的通知"],
                ["name": "发送带视频附件的通知"],
                ["name": "发送带多个附件的通知"],
                ["name": "尝试发送格式不支持的附件"]
            ]
        ]
    }
}




extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dict = dataArray[section~] {
            let list = dict["list"] as? [[String: String]] ?? []
            return list.count
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        if let dict = dataArray[section~] {
            let title = dict["title"] as? String ?? ""
            label.text = "    " + title
        }
        
        return label
    }

    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.makeCell(indexPath: indexPath)
        
        if let dict = dataArray[indexPath.section~] {

            let list = dict["list"] as? [[String: String]] ?? []
            
            let inDict = list[indexPath.row~] ?? [:]
            cell.textLabel?.text = inDict["name"] ?? ""
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
            case 0:
                didSelectSection0(atRow: indexPath.row)
            case 1:
                didSelectSection1(atRow: indexPath.row)
            case 2:
                didSelectSection2(atRow: indexPath.row)
            // ...
            default:
                break
            }

    }
    
}


