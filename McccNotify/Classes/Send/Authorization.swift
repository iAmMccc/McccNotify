import UserNotifications
import UIKit


extension McccNotify {
    public enum Authorization { }
}

/// 通知的权限管理
extension McccNotify.Authorization {
    
    /// 请求通知权限
    /// - Parameters:
    ///   - options: 权限选项，默认包含 `.alert`, `.sound`, `.badge`
    ///   - completion: 授权结果回调，返回是否授权成功及可能的错误
    public static func request(
        options: UNAuthorizationOptions = [.alert, .sound, .badge],
        completion: @escaping (Bool, Error?) -> Void
    ) {
        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
            
            NotifyLogger.log(level: .info, module: .authorization, message: "\(granted ? "同意通知授权" : "拒绝通知授权")")
            
            DispatchQueue.main.async {
                completion(granted, error)
            }
        }
    }
    
    
    /// 获取当前通知权限状态
    /// - Parameter completion: 回调返回当前的 `UNAuthorizationStatus`
    public static func getStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus)
            }
        }
    }
    
    /// 是否开启关键通知
    public static func isCriticalAlertEnabled(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.criticalAlertSetting == .enabled)
            }
        }
    }
    
    /// 跳转至系统设置中的当前 App 页面（用于引导用户手动开启通知权限）
    public static func openSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(settingsURL) else { return }
        
        UIApplication.shared.open(settingsURL)
    }
    
    /// 获取通知横幅风格
    /// UNAlertStyle：
    ///  - alert：持续的
    ///  - banner：临时的
    public static func alertStyle(completion: @escaping (UNAlertStyle) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.alertStyle)
            }
        }
    }
}

