//
//  DeliveryTermsShowModels.swift
//  CleanCase
//
//  Created by msm72 on 08.02.2018.
//  Copyright (c) 2018 msm72. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

// MARK: - Data models
enum DeliveryTermsShowModels {
    // MARK: - Use cases
    enum Data {
        struct RequestModel {
            struct ItemForPickerView: PickerViewSupport {
                // PickerViewSupport protocol implementation
                var id: String
                var title: String
            }
        }
        
        struct ResponseModel {
        }
        
        struct ViewModel {
        }
    }
}
