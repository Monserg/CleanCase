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
