//
//  Protocols.swift
//  CleanCase
//
//  Created by msm72 on 02.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//

import UIKit

protocol ConfigureCell {
    func setup(withItem item: Any, andIndexPath indexPath: IndexPath)
}

protocol InitCellParameters {
    var cellHeight: CGFloat { get set }
    var cellIdentifier: String { get set }
}


// Inject Dependencies
protocol HasRestAPIManager {
    var restAPIManager: RestAPIManager { get }
}

protocol HasCoreDataManager {
    var coreDataManager: CoreDataManager { get }
}
