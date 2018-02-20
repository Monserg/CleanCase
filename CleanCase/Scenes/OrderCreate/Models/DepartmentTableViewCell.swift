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
}
    

// MARK: - ConfigureCell
extension DepartmentTableViewCell: ConfigureCell {
    func setup(withItem item: Any, andIndexPath indexPath: IndexPath) {
        let department = item as! OrderCreateModels.Departments.RequestModel.DisplayedDepartment
        
        self.nameLabel.text     =   department.name
        self.accessoryType      =   .none

        selectionStyle          =   .none
    }
}
