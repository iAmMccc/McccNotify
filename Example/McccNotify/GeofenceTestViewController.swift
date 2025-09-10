//
//  GeofenceTestViewController.swift
//  McccNotify_Example
//
//  Created by qixin on 2025/9/10.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import UIKit
import CoreLocation

class GeofenceSimulationViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    
    // 围栏中心和半径
    let geofenceCenter = CLLocationCoordinate2D(latitude: 31.2304, longitude: 121.4737) // 上海中心
    let geofenceRadius: CLLocationDistance = 100 // 半径 100米
    
    // 模拟移动的路径（围栏外 → 内 → 外）
    let simulatedPath: [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: 31.2290, longitude: 121.4720), // 外
        CLLocationCoordinate2D(latitude: 31.2302, longitude: 121.4730), // 外
        CLLocationCoordinate2D(latitude: 31.2304, longitude: 121.4737), // 内
        CLLocationCoordinate2D(latitude: 31.2306, longitude: 121.4740), // 内
        CLLocationCoordinate2D(latitude: 31.2310, longitude: 121.4745)  // 外
    ]
    
    var timer: Timer?
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        startMonitoringGeofence()
        startSimulatedMovement()
    }
    
    // MARK: - 设置围栏
    func startMonitoringGeofence() {
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            let region = CLCircularRegion(center: geofenceCenter,
                                          radius: geofenceRadius,
                                          identifier: "TestGeofence")
            region.notifyOnEntry = true
            region.notifyOnExit = true
            locationManager.startMonitoring(for: region)
            print("✅ 开始监控围栏: \(region.identifier)")
        }
    }
    
    // MARK: - 自动模拟位置移动
    func startSimulatedMovement() {
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let coord = self.simulatedPath[self.index]
            self.simulateLocation(coord)
            self.index = (self.index + 1) % self.simulatedPath.count
        }
    }
    
    func simulateLocation(_ coordinate: CLLocationCoordinate2D) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        print("📍 模拟位置: \(coordinate.latitude), \(coordinate.longitude)")
        
        // 模拟器才会生效
        locationManager(locationManager, didUpdateLocations: [location])
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("✅ 进入围栏: \(region.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("❌ 离开围栏: \(region.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else { return }
        print("📍 当前真实/模拟位置: \(loc.coordinate.latitude), \(loc.coordinate.longitude)")
    }
}

