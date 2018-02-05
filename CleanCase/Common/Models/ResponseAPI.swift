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
