//
//  AppDelegate.swift
//  Todoey
//
//  Created by Fivecode on 13/07/19.
//  Copyright © 2019 Fivecode. All rights reserved.
//

import UIKit
import RealmSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true))
        do {
            try _ = Realm()
        } catch {
            print("Err initialization Realm: \(error)")
        }
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        return true
    }
    
}
