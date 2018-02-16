//
//  DepartmentItemTableViewCell.swift
//  CleanCase
//
//  Created by msm72 on 16.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//

import UIKit

class DepartmentItemTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    // MARK: - Class Functions
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}


extension DepartmentItemTableViewCell {
    func setup(withItem item: DepartmentItem, andIndexPath indexPath: IndexPath) {
        self.nameLabel.text     =   item.name
        self.priceLabel.text    =   String(format: "%@ %.2f", item.price, "Currency".localized())
        
        selectionStyle          =   .none
    }
}
