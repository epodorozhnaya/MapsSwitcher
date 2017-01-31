//
//  AppDelegate.swift
//  MapsSwitcher
//
//  Created by Lyoka on 1/22/17.
//  Copyright © 2017 Elena Podorozhnaya. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let didFirstLaunchKey = "didFirstLaunch"
        if !UserDefaults.standard.bool(forKey: didFirstLaunchKey) {
            
            UserDefaults.standard.set(true, forKey: didFirstLaunchKey)
            UserDefaults.standard.set(defaultMapProvider.rawValue, forKey: mapProviderKey)
            UserDefaults.standard.set(defaultGeocodingService.rawValue, forKey: geocodingServiceKey)
        }
        
        return true
    }
}

