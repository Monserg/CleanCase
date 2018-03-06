//
//  DepartmentCollectionViewCell.swift
//  CleanCase
//
//  Created by msm72 on 16.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//

import UIKit

class DepartmentCollectionViewCell: UICollectionViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
}


// MARK: - ConfigureCell
extension DepartmentCollectionViewCell: ConfigureCell {
    func setup(withItem item: Any, andIndexPath indexPath: IndexPath) {
        let department = item as! Department
        
        self.nameLabel.text = department.departmentName
        self.contentView.transform = CGAffineTransform(scaleX: -1, y: 1)
    }
}
