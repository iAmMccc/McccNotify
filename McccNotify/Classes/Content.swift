//
//  Content.swift
//  McccNotify
//
//  Created by qixin on 2025/7/7.
//

import Foundation


public final class ContentBuilder {
    private let content = UNMutableNotificationContent()

    public func title(_ title: String) {
        content.title = title
    }

    public func body(_ body: String) {
        content.body = body
    }

    public func defaultSound() {
        content.sound = .default
    }

    public func sound(named name: String) {
        content.sound = UNNotificationSound(named: UNNotificationSoundName(name))
    }

    public func criticalSound(name: String, volume: Float = 1.0) {
        if #available(iOS 12.0, *) {
            content.sound = UNNotificationSound.criticalSoundNamed(
                UNNotificationSoundName(name),
                withAudioVolume: min(max(volume, 0.0), 1.0)
            )
        }
    }

    func build() -> UNMutableNotificationContent {
        return content
    }
}
