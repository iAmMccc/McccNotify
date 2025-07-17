//
//  NotificationViewController.swift
//  NotificationContentExtension
//
//  Created by qixin on 2025/7/7.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import SnapKit

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.systemBackground
        
        
        // 为 cardView 添加渐变背景
        addGradientBackground(to: view)
        
        view.addSubview(cardView)
        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.top.equalToSuperview().offset(30)
        }
        
        view.addSubview(imageButton)
        imageButton.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.top.equalTo(titleLabel)
            make.width.height.equalTo(38)
        }
        
        view.addSubview(detailLabel)
        detailLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.preferredContentSize = CGSize(width: 0, height: 150)
//        self.preferredContentSize = self.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 当视图将要消失时，停止动画
        stopShakingAnimation()
    }
    
    // 为 cardView 添加渐变背景的方法
    func addGradientBackground(to view: UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor.orange.cgColor,
            UIColor.white.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func startShakingAnimation() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.1
        animation.repeatCount = Float.infinity // 无限重复
        animation.autoreverses = true
        
        let fromPoint = CGPoint(x: imageButton.center.x - 5, y: imageButton.center.y)
        let toPoint = CGPoint(x: imageButton.center.x + 5, y: imageButton.center.y)
        
        animation.fromValue = NSValue(cgPoint: fromPoint)
        animation.toValue = NSValue(cgPoint: toPoint)
        
        imageButton.layer.add(animation, forKey: "position")
    }
    
    func stopShakingAnimation() {
        // 停止动画
        imageButton.layer.removeAnimation(forKey: "position")
    }
    
    
    @objc func imageEvent() {
        print("点击了")
        startShakingAnimation()
    }
    
    
    func didReceive(_ notification: UNNotification) {
        self.label?.text = notification.request.content.body
        print("执行了UNNotificationContentExtension的didReceive")
    }
    lazy var cardView: UIView = {
        // 创建一个圆角背景卡片视图
        let cardView = UIView()
        cardView.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        cardView.layer.cornerRadius = 20
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.1
        cardView.layer.shadowOffset = CGSize(width: 0, height: 5)
        cardView.layer.shadowRadius = 10
        return cardView
    }()
    
    lazy var imageButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "clock"), for: .normal)
        btn.addTarget(self, action: #selector(imageEvent), for: .touchUpInside)
        return btn
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 36)
        label.textColor = UIColor.black
        label.text = "闹钟"
        return label
    }()
    
    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.darkText
        label.text = "你好阳光"
        return label
    }()
}
