//
//  Request.swift
//  McccNotify
//
//  Created by qixin on 2025/7/8.
//

import Foundation
import UserNotifications

//extension McccNotify {
//    public class Request {
//        private var identifier: String = UUID().uuidString
//        private var contentBuilder = ContentBuilder()
//        private var trigger: UNNotificationTrigger?
//
//        public init() {}
//
//        public func content(_ config: (ContentBuilder) -> Void) -> Self {
//            config(contentBuilder)
//            return self
//        }
//
//        public func trigger(timeInterval: TimeInterval, repeats: Bool = false) -> Self {
//            self.trigger = UNTimeIntervalNotificationTrigger(timeInterval: max(timeInterval, 0.1), repeats: repeats)
//            return self
//        }
//
//        public func trigger(components: DateComponents, repeats: Bool = false) -> Self {
//            self.trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: repeats)
//            return self
//        }
//
//        @discardableResult
//        public func send() -> UNNotificationRequest {
//            let finalTrigger = trigger ?? UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
//            let content = contentBuilder.build()
//            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: finalTrigger)
//            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
//            return request
//        }
//    }
//
//}
