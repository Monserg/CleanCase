//
//  DepartmentTableViewCell.swift
//  CleanCase
//
//  Created by msm72 on 13.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//

import UIKit

class DepartmentTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            nameLabel.textAlignment = .right
        }
    }
    
    
    // MARK: - Class Functions
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
    // MARK: - Custom Functions
    func setup(withItem item: OrderCreateModels.Departments.RequestModel.DisplayedDepartment, andIndexPath indexPath: IndexPath) {
        let department = item
        
        self.nameLabel.text = department.name
        self.accessoryType = .none

        selectionStyle = .none
    }
}
