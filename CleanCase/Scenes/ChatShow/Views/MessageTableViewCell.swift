//
//  ChatTableViewCell.swift
//  CleanCase
//
//  Created by Denis Miltsine on 21/03/2018.
//  Copyright © 2018 msm72. All rights reserved.
//

import UIKit
import DynamicColor

class MessageTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var labelsView: UIView!

    
    // MARK: - Class Functions
        override func awakeFromNib() {
            super.awakeFromNib()
        }
        
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
        }
    }
    
    
    // MARK: - Custom Functions
    extension MessageTableViewCell: ConfigureCell {
        func setup(withItem item: Any, andIndexPath indexPath: IndexPath) {
            let message = item as! Message
            
            self.messageLabel.text              =   message.text
            self.dateLabel.text                 =   message.date
            self.labelsView.backgroundColor     =   (message.type == 0) ? UIColor.white : DynamicColor(hexString: "#FAEBD8")
            
            selectionStyle  =   .none
        }
    }

