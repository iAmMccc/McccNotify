//
//  Center.swift
//  McccNotify
//
//  Created by qixin on 2025/7/8.
//

import Foundation
//extension McccNotify.Center {
//    
//    /// 添加通知
//    public static func add(
//        request: UNNotificationRequest,
//        completion: ((Error?) -> Void)? = nil
//    ) {
//        UNUserNotificationCenter.current().add(request, withCompletionHandler: completion)
//    }
//
//    /// 移除通知
//    public static func remove(identifiers: [String]) {
//        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
//    }
//
//    /// 移除所有
//    public static func removeAll() {
//        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
//    }
//
//    /// 查询所有待触发通知
//    public static func getPending(completion: @escaping ([UNNotificationRequest]) -> Void) {
//        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
//            DispatchQueue.main.async { completion(requests) }
//        }
//    }
//}
