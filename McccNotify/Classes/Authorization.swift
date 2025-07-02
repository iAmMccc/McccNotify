import UserNotifications
import UIKit

extension McccNotify {
    
    /// 管理通知权限相关操作：状态查询、请求授权、跳转设置页
    public enum Authorization {
        
        /// 获取当前通知权限状态
        /// - Parameter completion: 回调返回当前的 `UNAuthorizationStatus`
        public static func getStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                DispatchQueue.main.async {
                    completion(settings.authorizationStatus)
                }
            }
        }
        
        /// 请求通知权限
        /// - Parameters:
        ///   - options: 权限选项，默认包含 `.alert`, `.sound`, `.badge`
        ///   - completion: 授权结果回调，返回是否授权成功及可能的错误
        public static func request(
            options: UNAuthorizationOptions = [.alert, .sound, .badge],
            completion: @escaping (Bool, Error?) -> Void
        ) {
            UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
                DispatchQueue.main.async {
                    completion(granted, error)
                }
            }
        }
        
        /// 跳转至系统设置中的当前 App 页面（用于引导用户手动开启通知权限）
        public static func openSettings() {
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString),
                  UIApplication.shared.canOpenURL(settingsURL) else { return }
            
            UIApplication.shared.open(settingsURL)
        }
    }
}
