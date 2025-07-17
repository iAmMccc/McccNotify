//
//  Trigger.swift
//  McccNotify
//
//  Created by qixin on 2025/7/8.
//

import UserNotifications
import CoreLocation

extension McccNotify {

    /// 表示通知的触发方式
    public enum Trigger {
        
        /// 定时触发通知（从当前时刻延迟一定时间后触发）
        /// - Parameters:
        ///   - seconds: 延迟秒数（最小 0.1 秒）
        ///   - repeats: 是否重复触发（重复时系统要求最小间隔为 60 秒）
        case timeInterval(TimeInterval, repeats: Bool = false)

        /// 基于日历的触发方式（指定时间点触发）
        /// - Parameters:
        ///   - components: 日期组成，如 hour、minute、weekday 等
        ///   - repeats: 是否重复触发（如每周一早上 9 点）
        case calendar(DateComponents, repeats: Bool = false)

        /// 进入地理区域触发通知
        /// - Parameters:
        ///   - center: 区域中心坐标（纬度经度）
        ///   - radius: 区域半径（单位：米）
        ///   - identifier: 区域唯一标识（建议使用有业务语义的命名）
        ///   - repeats: 是否重复触发（通常设置为 true）
        ///
        /// ⚠️ 注意：
        /// - 每个 App 最多可同时注册 20 个地理围栏（CLRegion）
        /// - 如果你想同时支持“进入”与“离开”两个事件，应创建两条独立的通知
        /// - 使用时需确保用户授权定位权限，且 App 在后台可运行
        case locationOnEntry(center: CLLocationCoordinate2D, radius: CLLocationDistance, identifier: String, repeats: Bool = true)
        
        /// 离开地理区域触发通知
        /// - Parameters:
        ///   - center: 区域中心坐标（纬度经度）
        ///   - radius: 区域半径（单位：米）
        ///   - identifier: 区域唯一标识（建议使用有业务语义的命名）
        ///   - repeats: 是否重复触发（通常设置为 true）
        ///
        /// ⚠️ 注意：
        /// - 每个 App 最多可同时注册 20 个地理围栏（CLRegion）
        /// - 如果你想同时支持“进入”与“离开”两个事件，应创建两条独立的通知
        /// - 使用时需确保用户授权定位权限，且 App 在后台可运行
        case locationOnExit(center: CLLocationCoordinate2D, radius: CLLocationDistance, identifier: String, repeats: Bool = true)


        /// 将自定义 Trigger 枚举转换为系统的 UNNotificationTrigger
        func toUNNotificationTrigger() -> UNNotificationTrigger {
            switch self {
            case let .timeInterval(seconds, repeats):
                return UNTimeIntervalNotificationTrigger(timeInterval: max(seconds, 0.1), repeats: repeats)

            case let .calendar(components, repeats):
                return UNCalendarNotificationTrigger(dateMatching: components, repeats: repeats)

            case let .locationOnEntry(center, radius, id, repeats):
                let region = CLCircularRegion(center: center, radius: radius, identifier: id)
                region.notifyOnEntry = true
                region.notifyOnExit = false
                return UNLocationNotificationTrigger(region: region, repeats: repeats)

            case let .locationOnExit(center, radius, id, repeats):
                let region = CLCircularRegion(center: center, radius: radius, identifier: id)
                region.notifyOnEntry = false
                region.notifyOnExit = true
                return UNLocationNotificationTrigger(region: region, repeats: repeats)
            }
        }
    }
}
