//
//  Constants.swift
//  FindRes
//
//  Created by msm72 on 08.11.2017.
//  Copyright © 2017 RockSoft. All rights reserved.
//

import UIKit
import Alamofire

// Typealiases

// Closure
typealias HandlerPassDataCompletion     =   ((_ data: Any?) -> Void)


// Enums


// Constants
let heightRatio: CGFloat        =   UIScreen.main.bounds.height / 736
let widthRatio: CGFloat         =   UIScreen.main.bounds.width / 414
let isPhoneX                    =   UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436
let dispatchTimeDelay           =   0.1

var isNetworkAvailable: Bool {
    set { }
    
    get {
        let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")
        return reachabilityManager!.isReachable
    }
}
