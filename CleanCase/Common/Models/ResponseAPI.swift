//
//  ResponseAPI.swift
//  CleanCase
//
//  Created by msm72 on 02.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//

import UIKit

struct ResponseAPICities: Decodable {
    // MARK: - Properties
    let GetCitiesResult: [ResponseAPICity]
}

struct ResponseAPICity: Decodable {
    // MARK: - Properties
    let CityName: String
    let ID: Int16
}

struct ResponseAPIVersion: Decodable {
    let GetVerResult: Int16
}

struct ResponseAPILaundryResult: Decodable {
    // MARK: - Properties
    let GetLaundryByCityResult: ResponseAPILaundryInfo
}

struct ResponseAPILaundryInfo: Decodable {
    // MARK: - Properties
    let AddressLine: String?
    let BusinessId: String?
    let CityID: Int16
    let CityName: String
    let Header: String?
    let ID: Int16
    let Name: String?
    let Telephone: String?
}

struct ResponseAPICollectionDatesResult: Decodable {
    // MARK: - Properties
    let GetCollectionDatesResult: [ResponseAPICollectionDate]
}

struct ResponseAPICollectionDate: Decodable {
    // MARK: - Properties
    let CityName: String?
    let FromDate: String
    let LaundryId: Int16
    let Name: String?
    let Remarks: String?
    let ToDate: String
    let `Type`: Int16
    let WeekDay: Int16
}

struct ResponseAPIDeliveryDatesResult: Decodable {
    // MARK: - Properties
    let GetDeliveryDatesResult: [ResponseAPIDeliveryDate]
}

struct ResponseAPIDeliveryDate: Decodable {
    // MARK: - Properties
    let CityName: String?
    let FromDate: String
    let LaundryId: Int16
    let Name: String?
    let Remarks: String?
    let ToDate: String
    let `Type`: Int16
    let WeekDay: Int16
}

struct ResponseAPIDepartmentsResult: Decodable {
    // MARK: - Properties
    let GetDepartmentsResult: [ResponseAPIDepartment]
}

struct ResponseAPIDepartment: Decodable {
    // MARK: - Properties
    let DepartmentId: Int16
    let DepartmentName: String
    let Description: String?
    let Id: Int16
    let LaundryId: Int16
    let Items: [ResponseAPIDepartmentItem]?
}

struct ResponseAPIDepartmentItem: Decodable {
    // MARK: - Properties
    let DepartmentId: Int16
    let DepartmentItemId: Int16
    let DepartmentName: String
    let Description: String?
    let Id: Int16
    let Name: String
    let Price: Float
}

struct ResponseAPIClientResult: Decodable {
    // MARK: - Properties
    let AddClientResult: String
}

struct ResponseAPIAddOrderResult: Decodable {
    // MARK: - Properties
    let AddOrderResult: String
}

struct ResponseAPIUpdateStatusResult: Decodable {
    // MARK: - Properties
    let UpdateStatusResult: String
}

struct ResponseAPIOrderItemsResult: Decodable {
    // MARK: - Properties
    let GetItemsResult: [ResponseAPIOrderItem]?
}

struct ResponseAPIOrderItem: Decodable {
    // MARK: - Properties
    let DepartmentID: Int16
    let DepartmentItemID: Int16
    let Height: Float
    let ID: Int16
    let Name: String
    let OrderID: Int16
    let Price: Float
    let Qty: Int16
    let Width: Float
    
    let Status: ResponseAPIOrderItemStatus
}

struct ResponseAPIOrderItemStatus: Decodable {
    // MARK: - Properties
    let Color: Float?
    let ID: Int16
    let Path: String?
    let StatusName: String?
}

struct ResponseAPIClientMessageResult: Decodable {
    // MARK: - Properties
    let GetClientMessageResult: ResponseAPIClientMessageInfo
}

struct ResponseAPIClientMessageInfo: Decodable {
    // MARK: - Properties
    let ClientId: Int16
    let Command: Int16
    let CommandName: String
    let Data: String?
    let LaundryId: Int16
    let RecordId: Int64
}
