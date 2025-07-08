//
//  NotificationViewController.swift
//  NotificationContentExtension
//
//  Created by qixin on 2025/7/7.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        self.label?.text = notification.request.content.body
        print("执行了didReceive")
    }

}
