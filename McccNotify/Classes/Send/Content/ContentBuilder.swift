//
//  Content.swift
//  McccNotify
//
//  Created by qixin on 2025/7/7.
//

import Foundation


extension McccNotify {
    public final class ContentBuilder {
        private let content = UNMutableNotificationContent()

        public func title(_ title: String, subTitle: String? = nil) {
            content.title = title
            if let sub = subTitle {
                content.subtitle = sub
            }
        }
        
        public func badge(_ badge: Int) {
            content.badge = NSNumber(integerLiteral: badge)
        }

        public func body(_ body: String) {
            if body.count > 0 {
                content.body = body
            }
        }
        
        public func userInfo(_ userInfo: [AnyHashable: Any]) {
            content.userInfo = userInfo
        }
        
        /// 设置通知的线程 ID，用于通知分组展示
        public func threadIdentifier(_ id: String) {
            content.threadIdentifier = id
        }
    }
}


extension McccNotify.ContentBuilder {
    /// 设置普通通知声音
    ///
    /// - Parameter soundName: 自定义声音名称（应包含扩展名，如 "ding.m4a"）。若为 `nil` 则使用系统默认声音。
    public func normalSound(_ soundName: String? = nil) {
        if let soundName {
            content.sound = UNNotificationSound(named: UNNotificationSoundName(soundName))
        } else {
            content.sound = .default
        }
    }

    
    
    /// 设置铃声类型的通知声音（仅支持 iOS 15.2 及以上）
    ///
    /// - Parameter soundName: 铃声音频文件名，需包含扩展名（如 "alert.caf"）。若为 `nil`，使用系统默认铃声。
    ///
    /// ⚠️ 若设备系统低于 iOS 15.2，将回退为 `.default`
    public func ringtoneSound(_ soundName: String? = nil) {
        if #available(iOS 15.2, *) {
            if let soundName {
                content.sound = UNNotificationSound.ringtoneSoundNamed(UNNotificationSoundName(soundName))
            } else {
                content.sound = .defaultRingtone
            }
        } else {
            content.sound = .default
        }
    }
    
    
    /// 设置关键通知声音（Critical Alert），在静音或勿扰模式下依然响铃
        ///
        /// - Parameters:
        ///   - soundName: 自定义关键通知声音（需包含扩展名）。若为 `nil`，使用系统默认关键声音。
        ///   - volume: 播放音量，范围 `0.0 ~ 1.0`，默认 1.0
        ///
        /// ⚠️ 使用关键声音需：
        /// - 在 Info.plist 中声明 `UIBackgroundModes = critical-alert`
        /// - 请求授权时包含 `.criticalAlert`
        /// - 用户设置中开启“允许关键通知”
        ///
        /// ⚠️ iOS 12.0 以下系统将自动回退为 `.default`
        public func criticalSound(soundName: String? = nil, volume: Float = 1.0) {

            if #available(iOS 12.0, *) {
                if let soundName {
                    let clampedVolume = min(max(volume, 0.0), 1.0)
                    content.sound = UNNotificationSound.criticalSoundNamed(
                        UNNotificationSoundName(soundName),
                        withAudioVolume: clampedVolume
                    )
                } else {
                    content.sound = .defaultCritical
                }
            } else {
                content.sound = .default
            }
        }

}

extension McccNotify.ContentBuilder {
    /// 设置通知的附件数组。
    ///
    /// - 注意：
    /// 虽然 `attachments` 是一个数组，但系统在实际展示通知时通常只显示其中的一个附件（通常是第一个）。
    /// 如果使用了自定义通知扩展（Notification Content Extension），可以支持展示多个附件。
    /// 通常情况下，系统通知仅使用第一个附件进行展示。
    ///
    /// - Parameter attachments: 需要添加的通知附件数组。
    public func attachments(_ attachments: [UNNotificationAttachment]) {
        content.attachments = attachments
    }
    
    /// 设置通知的单个附件。
    ///
    /// - Parameter attachment: 需要添加的单个通知附件。
    /// - 该方法会将附件封装为数组形式赋值给通知内容。
    public func attachment(_ attachment: UNNotificationAttachment) {
        content.attachments = [attachment]
    }
}



extension McccNotify.ContentBuilder {
    /// 设置通知的中断等级（Interruption Level）
    /// - Parameter level: UNNotificationInterruptionLevel，控制通知打断用户的优先级
    ///   - .passive: 不打扰，仅显示通知中心和历史记录（最低优先级）
    ///   - .active: 普通通知，可能显示横幅，但不会绕过勿扰模式
    ///   - .timeSensitive: 时间敏感通知，允许绕过勿扰，适用于提醒等重要事项
    ///   - .critical: 关键通知，需申请特殊权限，最高优先级，会有声音且绕过静音
    public func interruptionLevel(_ level: UNNotificationInterruptionLevel) {
        content.interruptionLevel = level
    }
    
    /// 设置通知的相关性评分（Relevance Score）
    /// - Parameter score: 0.0 到 1.0 之间的 Double，越高表示通知对用户越重要
    ///   系统会据此排序通知，优先展示相关性更高的通知
    /// - 注意：该属性只影响通知排序，不保证通知一定优先展示
    public func relevanceScore(_ score: Double) {
        content.relevanceScore = score
    }
    
    /// 设置通知的过滤标签（Filter Criteria）
    /// - Parameter tag: 字符串标识，用户可自定义通知过滤规则
    ///   该属性仅 iOS 17 及以后系统支持
    /// - 作用：用户可通过系统通知设置过滤特定标签的通知，实现通知分类管理
    public func filterCriteria(_ tag: String) {
        if #available(iOS 17.0, *) {
            content.filterCriteria = tag
        }
    }
    
    /// 设置通知的目标内容标识符（Target Content Identifier）
    /// - Parameter id: 用于标识通知内容的唯一字符串
    ///   如果后续通知使用相同的 id，则会替换前一个通知，避免通知堆积
    /// - 作用：适合需要动态更新通知内容的场景，如任务状态更新、进度通知等
    public func targetContentIdentifier(_ id: String) {
        content.targetContentIdentifier = id
    }
    
}


extension McccNotify.ContentBuilder {
    
    func build() -> UNMutableNotificationContent {
        return content
    }
}
