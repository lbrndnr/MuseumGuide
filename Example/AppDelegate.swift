//
//  AppDelegate.swift
//  Example
//
//  Created by Laurin Brandner on 26/07/2015.
//  Copyright © 2015 Laurin Brandner. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = {
        let window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window.backgroundColor = .whiteColor()
        
        return window
    }()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
        
        return true
    }

}

