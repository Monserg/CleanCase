//
//  ChatTableViewCell.swift
//  CleanCase
//
//  Created by Denis Miltsine on 21/03/2018.
//  Copyright © 2018 msm72. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    // MaARK: - IBOutlets

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    // MARK: - Class Functions
        override func awakeFromNib() {
            super.awakeFromNib()
        }
        
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
        }
    }
    
    
    // MARK: - Custom Functions
    extension ChatTableViewCell: ConfigureCell {
        func setup(withItem item: Any, andIndexPath indexPath: IndexPath) {
            let message = item as! ChatShowModels.Message.RequestModel.DisplayedMessage
            
            self.messageLabel.text    =   message.text
            
            
            selectionStyle              =   .none
        }
    }

