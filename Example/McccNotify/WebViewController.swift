//
//  WebViewController.swift
//  McccNotify_Example
//
//  Created by qixin on 2025/7/18.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import UIKit

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var urlString: String = "" // 默认URL，可以替换成你需要的
    
    convenience init(url: String) {
        self.init()
        self.urlString = url
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWebView()
        loadURL()
    }
    
    private func setupWebView() {
        // 创建 WKWebView 实例
        webView = WKWebView(frame: view.bounds)
        webView.navigationDelegate = self
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(webView)
        
        // 添加加载进度观察（可选）
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    private func loadURL() {
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    // MARK: - WKNavigationDelegate
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // 页面开始加载
        print("开始加载页面")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // 页面加载完成
        print("页面加载完成")
        title = webView.title
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        // 页面加载失败
        print("加载失败: \(error.localizedDescription)")
    }
    
    // MARK: - 进度观察
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            // 可以在这里更新进度条
            print("加载进度: \(webView.estimatedProgress)")
        }
    }
    
    // MARK: - 清理
    
    deinit {
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }
}
