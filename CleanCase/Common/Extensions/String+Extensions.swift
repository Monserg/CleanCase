//
//  String+Extensions.swift
//  CleanCase
//
//  Created by msm72 on 05.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//

import UIKit

extension String {
    // MARK: - Properties
    var first: String {
        return String(prefix(1))
    }
    
    var last: String {
        return String(suffix(1))
    }
    
    func lowercaseFirst() -> String {
        return first.lowercased() + String(dropFirst())
    }

    var uppercaseFirst: String {
        return first.uppercased() + String(dropFirst())
    }
}
