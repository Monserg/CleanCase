//
//  SignInShowModels.swift
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
enum SignInShowModels {
    // MARK: - Use cases
    enum City {
        struct RequestModel {
        }
        
        struct ResponseModel {
            struct ItemForPickerView: PickerViewSupport {
                // PickerViewSupport protocol implementation
                var id: Int16
                var title: String
            }
        }
        
        struct ViewModel {
        }
    }

    enum Laundry {
        struct RequestModel {
        }
        
        struct ResponseModel {
        }
        
        struct ViewModel {
        }
    }

    enum Date {
        struct RequestModel {
        }
        
        struct ResponseModel {
        }
        
        struct ViewModel {
        }
    }

    enum Department {
        struct RequestModel {
        }
        
        struct ResponseModel {
        }
        
        struct ViewModel {
        }
    }
}
