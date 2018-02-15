//
//  OrderItemTableViewCell.swift
//  CleanCase
//
//  Created by msm72 on 15.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//

import UIKit

class OrderItemTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    @IBOutlet var labelsCollection: [UILabel]! {
        didSet {
            _ = labelsCollection.map({ $0.text = nil })
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
    func setup(withItem item: OrderItem, withOrderStatus orderStatus: Int16, andIndexPath indexPath: IndexPath) {
        let orderItem = item
        
        self.nameLabel.text         =   item.name ?? ""
        self.priceLabel.text        =   String(format: "%@ %.2f", orderItem.price, "Currency".localized())
        
        // Price display when status is "Ready"(3), "Closed"(2) or "InWayToClient"(8)
        self.priceLabel.isHidden    =   (orderStatus == 2 || orderStatus == 3 || orderStatus == 8) ? true : false
        
        self.quantityLabel.text     =   "\(orderItem.quantity)"
        
        selectionStyle              =   .none
    }
}
