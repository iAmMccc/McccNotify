//
//  NotifyLogger.swift
//  McccNotify
//
//  Created by qixin on 2025/7/10.
//

import Foundation


enum NotifyLogLevel: String {
    case info = "ℹ️"
    case warning = "⚠️"
    case error = "❌"
}

enum NotifyLogModule {
    case attachment
    case authorization
    case category
    
    var desc: String {
        switch self {
        case .attachment:
            return "通知附件"
        case .authorization:
            return "通知授权"
        case .category:
            return "通知分类"
        }
    }
}

struct NotifyLogger {
    static var isEnabled: Bool = true  // 可控制全局开关
    static var prefix: String = "McccNotify"

    static func log(level: NotifyLogLevel, module: NotifyLogModule, message: String) {
        guard isEnabled else { return }
        print("\(level.rawValue) ⎣\(prefix) ▪︎ \(module.desc)⎤ ⁃ \(message)")
    }
    
}
