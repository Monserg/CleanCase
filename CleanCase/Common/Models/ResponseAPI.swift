//
//  ResponseAPI.swift
//  CleanCase
//
//  Created by msm72 on 02.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//

import UIKit

struct GetCitiesResult: Decodable {
    // MARK: - Properties
    let GetCitiesResult: [ResponseCity]
}

struct ResponseCity: Decodable {
    // MARK: - Properties
    let CityName: String
    let ID: Int16
}
