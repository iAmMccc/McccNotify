//
//  McccNotify+Management.swift
//  McccNotify
//
//  Created by qixin on 2025/7/8.
//

import Foundation
import UserNotifications

extension McccNotify {
    public enum Request { }
}
extension McccNotify.Request {
    /// 查询所有待发送（Pending）通知
    public static func getPending(completion: @escaping ([UNNotificationRequest]) -> Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            DispatchQueue.main.async {
                completion(requests)
            }
        }
    }
    
    /// 查询是否存在指定 ID 的待发送通知
    public static func hasPending(id: String, completion: @escaping (Bool) -> Void) {
        getPending { requests in
            let exists = requests.contains { $0.identifier == id }
            completion(exists)
        }
    }
    
    /// 删除所有待发送通知
    public static func removeAllPending() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    
    /// 删除指定标识符的待发通知
    public static func removePending(ids: [String]) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)
    }
}


extension McccNotify.Request {

    /// 获取所有已送达（Delivered）通知
    public static func getDelivered(completion: @escaping ([UNNotification]) -> Void) {
        UNUserNotificationCenter.current().getDeliveredNotifications { notifications in
            DispatchQueue.main.async {
                completion(notifications)
            }
        }
    }
    /// 查询是否存在指定 ID 的已送达通知
    public static func hasDelivered(id: String, completion: @escaping (Bool) -> Void) {
        getDelivered { notifications in
            let exists = notifications.contains { $0.request.identifier == id }
            completion(exists)
        }
    }

    /// 删除所有已送达通知
    public static func removeAllDelivered() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }

    
    /// 删除指定已发送的通知
    public static func removeDelivered(ids: [String]) {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ids)
    }
}


extension McccNotify.Request {
    
    /// 查询指定 requestID 的通知的下一次触发时间
    public static func nextTriggerDate(id: String, completion: @escaping (Date?) -> Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            guard let trigger = requests.first(where: { $0.identifier == id })?.trigger else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            
            let next: Date?
            
            switch trigger {
            case let timeTrigger as UNTimeIntervalNotificationTrigger:
                next = timeTrigger.nextTriggerDate()
            case let calendarTrigger as UNCalendarNotificationTrigger:
                next = calendarTrigger.nextTriggerDate()
            default:
                next = nil
            }
            
            DispatchQueue.main.async {
                completion(next)
            }
        }
    }
}
