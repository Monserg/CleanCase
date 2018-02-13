//
//  OrderCreateModels.swift
//  CleanCase
//
//  Created by msm72 on 02.02.2018.
//  Copyright (c) 2018 msm72. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

// MARK: - Data models
enum OrderCreateModels {
    // MARK: - Use cases
    enum Dates {
        struct RequestModel {
            struct DateForPickerView: PickerViewSupport {
                // PickerViewSupport protocol implementation
                var id: Int16
                var title: String
                
                var times: [PickerViewSupport]
            }
            
            struct TimeForPickerView: PickerViewSupport {
                // PickerViewSupport protocol implementation
                var id: Int16
                var title: String
                
                var bodyDate: String
                var bodyTimeFrom: String
                var bodyTimeTo: String
            }
        }
        
        struct ResponseModel {
        }
        
        struct ViewModel {
        }
    }

    enum Departments {
        struct RequestModel {
            struct DisplayedDepartment {
                var id: Int16
                var name: String
                var isSelected: Bool
            }
        }
        
        struct ResponseModel {
        }
        
        struct ViewModel {
        }
    }
    
    enum Order {
        struct RequestModel {
            let bodyParams: [ String: Any ]
        }
        
        struct ResponseModel {
            let error: Error?
        }
        
        struct ViewModel {
            let error: Error?
        }
    }
}
