//
//  AppDelegate.swift
//  ToDoey
//
//  Created by Khaled Bohout on 4/21/19.
//  Copyright © 2019 Khaled Bohout. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
      //  print("khaled: \(Realm.Configuration.defaultConfiguration.fileURL)")

        do {
            _ = try Realm()
        } catch{
          print("error installing realm , \(error)")
        }
        
        return true
    }


    func applicationWillTerminate(_ application: UIApplication) {

       
    }
    
    
}

