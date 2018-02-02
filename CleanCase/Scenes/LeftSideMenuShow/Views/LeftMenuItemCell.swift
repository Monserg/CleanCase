//
//  LeftMenuItemCell.swift
//  FindRes
//
//  Created by msm72 on 09.11.2017.
//  Copyright © 2017 RockSoft. All rights reserved.
//

import UIKit
import SideMenu

class LeftMenuItemCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var separatorLineView: UIView! {
        didSet {
            separatorLineView.backgroundColor = UIColor.lightGray
        }
    }
    
    
    // MARK: - Class Initialization
    override func awakeFromNib() {
        super.awakeFromNib()

//        titleLabel.font                         =   UIFont.setupBy("Calibri", withStyle: .Bold, andSize: 22.0)
//        titleLabel.textColor                    =   UIColor.veryDarkGrayishBlue
//        titleLabel.textAlignment                =   .left
//        titleLabel.adjustsFontSizeToFitWidth    =   true
//        titleLabel.minimumScaleFactor           =   0.5
//        titleLabel.numberOfLines                =   0
    }
}


// MARK: - ConfigureCell
extension LeftMenuItemCell: ConfigureCell {
    func setup(withItem item: Any, andIndexPath indexPath: IndexPath) {
        let menuItem = item as! LeftSideMenuShowModels.MenuItems.ResponseModel.MenuItem
        
        itemTitleLabel.text = menuItem.title
        itemImageView.image = UIImage.init(named: menuItem.iconName)
        selectionStyle = .none
    }
}
