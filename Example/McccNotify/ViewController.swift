//
//  ViewController.swift
//  McccNotify
//
//  Created by Mccc on 06/30/2025.
//  Copyright (c) 2025 Mccc. All rights reserved.
//

import UIKit
import McccNotify


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        McccNotify.Authorization.getStatus { status in
            print(status.rawValue)
        }
        
        
        McccNotify.Authorization.request { granted, error in
            print(granted)
            print(error)
        }
        
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        McccNotify.Authorization.openSettings()
    }
}



/**
 
 public enum UNAuthorizationStatus : Int, @unchecked Sendable {

     case notDetermined = 0

     case denied = 1

     case authorized = 2

     @available(iOS 12.0, *)
     case provisional = 3

     @available(iOS 14.0, *)
     case ephemeral = 4
 }
 */
