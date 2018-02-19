//
//  AppDelegate.swift
//  CleanCase
//
//  Created by msm72 on 02.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//

import UIKit
import Firebase
import SKStyleKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: - Properties
    var window: UIWindow?
    
    
    // MARK: - Class Functions
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Add SKStyleKit
        StyleKit.initStyleKit()
        
        // Set navbar & status bar color
        let style = StyleKit.style(withName: "defaultBarTintColorStyle")!
        
        UINavigationBar.appearance().shadowImage            =   UIImage()                   // NavBar bottom line
        UINavigationBar.appearance().barTintColor           =   style.backgroundColor!      // Navbar background color
        UINavigationBar.appearance().tintColor              =   .white                      // Navbar items color
        
        UIApplication.shared.statusBarStyle                 =   .lightContent
        UIApplication.shared.statusBarView?.backgroundColor =   UIColor.black
        
        // Add Firebase
        FirebaseApp.configure()
        
        // CoreData: update current App version
        CoreDataManager.instance.updateEntity(withData: EntityUpdateTuple(name:         "Version",
                                                                          predicate:    nil,
                                                                          model:        ResponseAPIVersion(GetVerResult: Bundle.main.versionNumber)))
        
        sleep(1)
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
