//
//  UIApplication+Extension.swift
//  FindRes
//
//  Created by msm72 on 14.11.2017.
//  Copyright © 2017 RockSoft. All rights reserved.
//

import UIKit

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}
