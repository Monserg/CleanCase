//
//  AppDelegate.swift
//  CleanCase
//
//  Created by msm72 on 02.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//

import UIKit
import Fabric
import Firebase
import SKStyleKit
import Crashlytics
import Localize_Swift
import FirebaseMessaging
import UserNotifications
import FirebaseInstanceID

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: - Properties
    var window: UIWindow?
    var showDeliveryTermsTimer: CustomTimer = CustomTimer(withSecondsInterval: 30)

    
    // MARK: - Class Functions
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Set default App language
        if let languageCode = UserDefaults.standard.value(forKey: "languageApp") as? String {
            Localize.setCurrentLanguage(languageCode)
        }
        
        else {
            Localize.setCurrentLanguage("he")
        }
        
        Logger.log(message: "App language is \(Localize.currentLanguage())", event: .Info)

        // Add SKStyleKit
        StyleKit.initStyleKit()
        
        // Start Fabric
        Fabric.with([Crashlytics.self])

        // Set navbar & status bar color
        let style = StyleKit.style(withName: "defaultBarTintColorStyle")!
        
        UINavigationBar.appearance().shadowImage            =   UIImage()                   // NavBar bottom line
        UINavigationBar.appearance().barTintColor           =   style.backgroundColor!      // Navbar background color
        UINavigationBar.appearance().tintColor              =   .white                      // Navbar items color
        
        UIApplication.shared.statusBarStyle                 =   .lightContent
        UIApplication.shared.statusBarView?.backgroundColor =   UIColor.black
        
        // Use Firebase library to configure APIs
        FirebaseApp.configure()

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
        }
        
        else {
            Logger.log(message: "Stored Firebase token: \(Token.current!.firebase ?? "firebaseTokenXXX"), device token: \(Token.current!.device ?? "deviceTokenXXX")", event: .Severe)
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
        self.showDeliveryTermsTimer.suspend()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        application.applicationIconBadgeNumber = 0

        // Run Update Status Timer
        self.showDeliveryTermsTimer.resume()
        
        self.showDeliveryTermsTimer.eventHandler = {
            // Core Data: load last Order with empty Delivety Date & Time
            if Order.firstToChangeStatus != nil {
                Logger.log(message: "Post Notification to show Delivery Terms scene", event: .Debug)
                NotificationCenter.default.post(name: Notification.Name("ShowDeliveryTermsScene"), object: nil)
            }
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        self.showDeliveryTermsTimer.suspend()
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
        Logger.log(message: "Register for Remote Notifications failed: \(error.localizedDescription)", event: .Error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // App in Active mode & after tap on notification
//        application.applicationIconBadgeNumber += 1
        Logger.log(message: "Received Remote Notification message: \(userInfo), badge = \(application.applicationIconBadgeNumber)", event: .Severe)
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
        Logger.log(message: "Received Firebase token: \(fcmToken)", event: .Severe)
    }
    
    func application(received remoteMessage: MessagingRemoteMessage) {
        Logger.log(message: "Received Remote message: \(remoteMessage.appData)", event: .Severe)
    }
}


// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
        UIApplication.shared.applicationIconBadgeNumber += 1
        Logger.log(message: "Present User Notification, badge = \(UIApplication.shared.applicationIconBadgeNumber)", event: .Severe)
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        Logger.log(message: "Receive User Notification, badge = \(UIApplication.shared.applicationIconBadgeNumber)", event: .Severe)
    }
}
