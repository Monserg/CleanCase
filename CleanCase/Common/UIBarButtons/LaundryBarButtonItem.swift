//
//  LaundryBarButtonItem.swift
//  CleanCase
//
//  Created by msm72 on 03.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//

import UIKit

class LaundryBarButtonItem: UIBarButtonItem {
    // MARK: - Class Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
     
//        addLaundryInfo(withName: "Zorro")
    }

    
    // MARK: - Custom Functions
    public func addLaundryInfo(withName name: String) {
        self.customView = LaundryView(withName: name)
        print(name)
    }
}
