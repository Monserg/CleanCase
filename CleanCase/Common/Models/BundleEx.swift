//
//  BundleEx.swift
//  CleanCase
//
//  Created by msm72 on 05.03.2018.
//  Copyright © 2018 msm72. All rights reserved.
//

import Foundation

class BundleEx {
    // MARK: - Properties
    var languageBundle: Bundle?
    
    
    // MARK: - Custom Functions
    func language() {
        let languageCode = UserDefaults.standard
        
        if UserDefaults.standard.value(forKey: "languageApp") != nil {
            let language = languageCode.string(forKey: "languageApp")!
            
            if let path = Bundle.main.path(forResource: language, ofType: "lproj") {
                languageBundle = Bundle(path: path)
            }
            
            else{
                languageBundle = Bundle(path: Bundle.main.path(forResource: "en", ofType: "lproj")!)
            }
        }
            
        else {
            languageCode.set("en", forKey: "languageApp")
            languageCode.synchronize()
            let language = languageCode.string(forKey: "languageApp")!
            
            if let path = Bundle.main.path(forResource: language, ofType: "lproj") {
                languageBundle = Bundle(path: path)
            }
            
            else{
                languageBundle = Bundle(path: Bundle.main.path(forResource: "en", ofType: "lproj")!)
            }
        }
    }
}
