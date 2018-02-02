//
//  ErrorManager.swift
//  CleanCase
//
//  Created by msm72 on 02.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//

import UIKit

public enum StatusCodeNote: Int {
    case SUCCESS                    =   200     //  GET or DELETE result is successful
    case CONTINUE                   =   2201    //  POST result is successful & need continue
    case CREATED                    =   201     //  POST or PUT is successful
    case NOT_MODIFIED               =   304     //  If caching is enabled and etag matches with the server
    case SOMETHING_WRONG_3894       =   3894
    case BAD_REQUEST_400            =   400     //  Possibly the parameters are invalid
    case INVALID_CREDENTIAL         =   401     //  INVALID CREDENTIAL, possible invalid token
    case NOT_FOUND                  =   404     //  The item you looked for is not found
    case INCORRECT_PHONE_NUMBER     =   406     //  Phone number is not supported
    case CONFLICT                   =   409     //  Conflict - means already exist
    case AUTHENTICATION_EXPIRED     =   419     //  Expired
    case WRONG_SHOW_INFO            =   4200    //  Failed on showing info
    case BAD_AUTHORIZATION          =   4401    //  BAD AUTHORIZATION
    case INCORRECT_PASSWORD         =   4402    //  PASSWORD IS INCORRECT
    case SOMETHING_WRONG_4222       =   4222    //  User does not exist
    case BAD_REQUEST_4444           =   4444    //  BAD REQUEST
    case WRONG_INPUT_DATA           =   4500    //  WRONG INPUT DATA
    case USER_EXIST                 =   4670
    case REQUEST_HANDLING_FAIL      =   5005    //  SQL processing failed
    case ORG_NAME_EXIST             =   6992    //  NAME OF ORG HAS UNIQUE CONSTRAIN
    case TIMESHEET_BROKEN           =   8100    //  Timesheet is not available
    
    var name: String {
        get { return String(describing: self) }
    }
}

class ErrorManager: Error {
    // MARK: - Custom Functions
    static func create(fromErrorCode code: Int) -> Error {
        return NSError(domain: StatusCodeNote.init(rawValue: code)!.name.localized(), code: code, userInfo: nil)
    }
}
