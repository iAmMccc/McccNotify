//
//  AttachmentBuilder.swift
//  McccNotify
//
//  Created by qixin on 2025/7/8.
//

import Foundation
import UserNotifications
import UIKit


extension McccNotify {
    /// 构建通知附件的链式构造器
    public final class AttachmentBuilder {
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
                print("❌ 无法加载 .xcassets 图片或转为 PNG：\(name)")
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
                print("❌ 创建 xcassets 图片附件失败：\(error)")
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
                print("❌ 找不到 Bundle 文件资源：\(name).\(ext)")
                return self
            }

            let id = identifier ?? name
            do {
                let attachment = try UNNotificationAttachment(identifier: id, url: url)
                attachments.append(attachment)
            } catch {
                print("❌ 创建附件失败：\(error)")
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
                print("❌ 创建本地路径附件失败：\(error)")
            }

            return self
        }

        /// 构建最终附件数组
        public func build() -> [UNNotificationAttachment] {
            return attachments
        }
    }

}
