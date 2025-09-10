//
//  AttachmentBuilder.swift
//  McccNotify
//
//  Created by qixin on 2025/7/8.
//

import Foundation
import UserNotifications
import UIKit


/// 构建通知附件的链式构造器
public final class McccNotifyAttachment {
    private var attachments: [UNNotificationAttachment] = []
    
    public init() {}
    
    /// 添加已有的附件对象
    @discardableResult
    public func add(_ attachment: UNNotificationAttachment) -> Self {
        attachments.append(attachment)
        return self
    }
    
    /// 添加多个附件
    @discardableResult
    public func add(_ attachments: [UNNotificationAttachment]) -> Self {
        self.attachments.append(contentsOf: attachments)
        return self
    }
    
    
    /// 从 SF Symbol 创建通知附件（渲染为 PNG）
    /// - Parameters:
    ///   - systemName: SF Symbol 名称，例如 "bell.fill"
    ///   - identifier: 附件 ID，默认 UUID
    ///   - pointSize: 渲染尺寸（默认 100）
    ///   - weight: 字重（默认 .regular）
    ///   - scale: 渲染比例（默认 .default）
    ///   - tintColor: 渲染颜色（默认黑色）
    @discardableResult
    public func addSFSymbol(_ name: String, tintColor: UIColor, pointSize: CGFloat = 50, identifier: String? = nil) -> Self {
        let config = UIImage.SymbolConfiguration(pointSize: pointSize, weight: .regular)
        guard let symbolImage = UIImage(systemName: name, withConfiguration: config)?
            .withTintColor(tintColor, renderingMode: .alwaysOriginal),
              let data = symbolImage.pngData() else {
            NotifyLogger.log(level: .error, module: .attachment, message: "生成 SF Symbol PNG 失败")
            return self
        }
        
        let id = identifier ?? UUID().uuidString
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(id).png")
        do {
            try? FileManager.default.removeItem(at: fileURL)
            try data.write(to: fileURL)
            let attachment = try UNNotificationAttachment(identifier: id, url: fileURL)
            attachments.append(attachment)
        } catch {
            NotifyLogger.log(level: .error, module: .attachment, message: "生成附件失败: \(error)")
        }
        
        return self
    }
    
    /// 从 `.xcassets` 中加载图片，并写入临时目录生成附件（转为 PNG）
    ///
    /// - Parameters:
    ///   - name: 图片资源名（不带扩展名）
    ///   - identifier: 附件 ID，默认为 UUID
    ///   - bundle: 资源所在 Bundle，默认为主 Bundle
    @discardableResult
    public func addAssetImage(named name: String, identifier: String? = nil, bundle: Bundle = .main) -> Self {
        guard let image = UIImage(named: name, in: bundle, compatibleWith: nil),
              let data = image.pngData() else {
            NotifyLogger.log(level: .error, module: .attachment, message: "找不到名为 [\(name)] 的 .xcassets 图片，或无法转为 PNG。")
            return self
        }
        
        let id = identifier ?? UUID().uuidString
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(id).png")
        
        do {
            try? FileManager.default.removeItem(at: fileURL)
            try data.write(to: fileURL)
            let attachment = try UNNotificationAttachment(identifier: id, url: fileURL)
            attachments.append(attachment)
        } catch {
            NotifyLogger.log(level: .error, module: .attachment, message: "无法将图片写入临时目录 [\(fileURL.lastPathComponent)]，错误：\(error)")
        }
        
        return self
    }
    
    /// 从 Bundle 中加载可访问的文件资源，并构建为通知附件
    ///
    /// - 适用于你直接拖入工程的 PNG、JPG、MP3、MP4、PDF 等资源文件（非 `.xcassets`）
    /// - 文件资源必须实际存在于 Bundle 中，可被 `Bundle.url(forResource:withExtension:)` 访问
    ///
    /// - Parameters:
    ///   - name: 文件名（不含扩展名）
    ///   - ext: 扩展名，如 "jpg"、"mp3"、"mp4"
    ///   - identifier: 附件 ID，默认为文件名
    ///   - bundle: 所在资源包，默认使用主 Bundle
    @discardableResult
    public func addFile(named name: String, withExtension ext: String, identifier: String? = nil, bundle: Bundle = .main) -> Self {
        guard let url = bundle.url(forResource: name, withExtension: ext) else {
            NotifyLogger.log(level: .error, module: .attachment, message: "找不到 Bundle 文件资源：\(name).\(ext)")
            
            return self
        }
        
        let id = identifier ?? name
        do {
            let attachment = try UNNotificationAttachment(identifier: id, url: url)
            attachments.append(attachment)
        } catch {
            NotifyLogger.log(level: .error, module: .attachment, message: "创建本地路径附件失败：\(error)")
        }
        
        return self
    }
    
    /// 从本地路径直接加载附件文件
    ///
    /// - Parameters:
    ///   - url: 本地文件 URL
    ///   - identifier: 附件 ID，默认为 UUID
    @discardableResult
    public func addFile(at url: URL, identifier: String? = nil) -> Self {
        let id = identifier ?? UUID().uuidString
        do {
            let attachment = try UNNotificationAttachment(identifier: id, url: url)
            attachments.append(attachment)
        } catch {
            NotifyLogger.log(level: .error, module: .attachment, message: "创建本地路径附件失败：\(error)")
        }
        
        return self
    }
    
    
    /// 构建最终附件数组
    public func build() -> [UNNotificationAttachment] {
        return attachments
    }
}


extension McccNotifyAttachment {
    
    
    public enum Resource {
        case image(url: URL)
        case video(url: URL)
        case audio(url: URL)
        
        public func getUrl() -> URL {
            switch self {
            case .image(let url):
                return url
            case .video(let url):
                return url
            case .audio(let url):
                return url
            }
        }
    }
    
    /// 从userInfo中提取媒体URL
    /// - Parameter userInfo: 通知的用户信息字典
    /// - Returns: 元组(URL字符串, 是否是视频)
    public static func identifyResource(from userInfo: [AnyHashable: Any]) -> Resource? {
        
        if let str = userInfo["image-url"] as? String, let url = URL(string: str) {
            return .image(url: url)
        } else if let str = userInfo["video-url"] as? String, let url = URL(string: str) {
            return .image(url: url)
        } else if let str = userInfo["audio-url"] as? String, let url = URL(string: str) {
            return .image(url: url)
        }
        return nil
    }
    
    
    
    
    /// 从远程URL下载并创建通知附件
    /// - Parameters:
    ///   - url: 远程资源URL
    ///   - identifier: 附件唯一标识符（默认自动生成UUID）
    ///   - options: 附件配置选项
    ///   - completion: 完成回调(Result<UNNotificationAttachment, Error>)
    public static func downloadAttachment(
        from url: URL,
        identifier: String? = nil,
        options: [String: Any] = [:],
        completion: @escaping (Result<UNNotificationAttachment, Error>) -> Void) {
            let id = identifier ?? UUID().uuidString
            
            let session = URLSession(configuration: .default)
            let task = session.downloadTask(with: url) { localURL, _, error in
                guard let localURL = localURL else {
                    let error = error ?? NSError(domain: "AttachmentBuilder", code: -1, userInfo: [NSLocalizedDescriptionKey: "下载失败"])
                    NotifyLogger.log(level: .error, module: .attachment, message: "附件下载失败：\(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }
                
                let fileManager = FileManager.default
                let tmpDir = URL(fileURLWithPath: NSTemporaryDirectory())
                let tmpFile = tmpDir.appendingPathComponent(url.lastPathComponent)
                
                do {
                    if fileManager.fileExists(atPath: tmpFile.path) {
                        try fileManager.removeItem(at: tmpFile)
                    }
                    try fileManager.moveItem(at: localURL, to: tmpFile)
                    
                    let attachment = try UNNotificationAttachment(identifier: id,
                                                                  url: tmpFile,
                                                                  options: options)
                    
                    completion(.success(attachment))
                } catch {
                    NotifyLogger.log(level: .error, module: .attachment, message: "附件处理失败：\(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
            task.resume()
        }
}

