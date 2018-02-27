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
import FirebaseMessaging
import UserNotifications
import FirebaseInstanceID


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: - Properties
    var window: UIWindow?
    var updateStatusTimer: CustomTimer = CustomTimer(withSecondsInterval: 60)

    
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
        
        // Register for remote notifications
        if Token.current == nil {
            // For iOS 10 data message (sent via FCM)
            Messaging.messaging().delegate                  =   self

            if #available(iOS 10.0, *) {
                // For iOS 10 display notification (sent via APNS)
                UNUserNotificationCenter.current().delegate =   self
                let authOptions: UNAuthorizationOptions     =   [ .alert, .badge, .sound ]
                
                UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in })
            }
                
            else {
                let settings: UIUserNotificationSettings    =   UIUserNotificationSettings(types: [ .alert, .badge, .sound ], categories: nil)
                
                application.registerUserNotificationSettings(settings)
            }
            
            application.registerForRemoteNotifications()
            
            // Use Firebase library to configure APIs
            FirebaseApp.configure()
        }
        
        
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
        self.updateStatusTimer.suspend()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        // Run Update Status Timer
        self.updateStatusTimer.resume()
        
        self.updateStatusTimer.eventHandler = {
            // Core Data: load last Order with empty Delivety Date & Time
            if Order.firstToChangeStatus != nil {
                NotificationCenter.default.post(name: Notification.Name("TimerNotificationComplete"), object: nil)
            }
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        self.updateStatusTimer.suspend()
    }
    
    
    // MARK: - Remote Push Notifications
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        let token = deviceToken.reduce("") { $0 + String(format: "%02x", $1) }

        if Token.current == nil {
            _ = CoreDataManager.instance.createEntity("Token")
        }
        
        Token.current!.device = token
        Token.current!.save()
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Print full Remote Push Notification message
        print("TEST: receive RPN message = \(userInfo)")
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
}


// MARK: - MessagingDelegate
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        if Token.current == nil {
            _ = CoreDataManager.instance.createEntity("Token")
        }
        
        Token.current!.firebase = fcmToken
        Token.current!.lastMessageID = 0
        Token.current!.save()
        
        print("TEST: Firebase token = \(fcmToken)")
    }
    
    func application(received remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
}


// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
        print("dddd1")
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        print("dddd2")
    }
}
