//
//  Bundle+Extensions.swift
//  CleanCase
//
//  Created by msm72 on 03.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//

import UIKit

extension Bundle {
    var versionNumber: Int16 {
        if let versionString = infoDictionary?["CFBundleShortVersionString"] as? String {
            return Int16(versionString)!
        }
        
        return 0
    }
    
    var buildNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
