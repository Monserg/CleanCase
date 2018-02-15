//
//  Constants.swift
//  CleanCase
//
//  Created by msm72 on 02.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//

import UIKit
import Alamofire

// Typealiases
typealias EntityUpdateTuple     =   (name: String, predicate: NSPredicate?, model: Decodable)


// Closure
typealias HandlerPassDataCompletion     =   ((_ data: Any?) -> Void)


// Enums


// Constants
let heightRatio: CGFloat        =   UIScreen.main.bounds.height / 736
let widthRatio: CGFloat         =   UIScreen.main.bounds.width / 414
let isPhoneX                    =   UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436
let dispatchTimeDelay           =   0.1
let logAPI                      =   "http://192.116.53.69/Facade/log.txt"


var isNetworkAvailable: Bool {
    set { }
    
    get {
        let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")
        return reachabilityManager!.isReachable
    }
}
