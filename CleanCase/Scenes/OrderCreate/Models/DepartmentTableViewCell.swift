//
//  DepartmentTableViewCell.swift
//  CleanCase
//
//  Created by msm72 on 13.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//

import UIKit
import M13Checkbox

class DepartmentTableViewCell: UITableViewCell {
    // MARK: - Properties
    var handlerCheckboxTap: ((M13Checkbox.CheckState) -> ())?
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var checkbox: M13Checkbox! {
        didSet {
            checkbox.boxType = .square
        }
    }
    
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
    func changeCheckbox() {
        self.handlerChangeValue(self.checkbox)
    }
    
    
    // MARK: - Actions
    @IBAction func handlerChangeValue(_ sender: M13Checkbox) {
        self.handlerCheckboxTap!(sender.checkState)
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
