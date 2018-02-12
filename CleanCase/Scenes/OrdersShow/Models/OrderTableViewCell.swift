//
//  OrderTableViewCell.swift
//  CleanCase
//
//  Created by msm72 on 12.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var collectedLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var deliveryLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    // MARK: - Class Functions
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    // MARK: - Custom Functions
    func setup(withItem item: OrdersShowModels.OrderItem.RequestModel.DisplayedOrder, andIndexPath indexPath: IndexPath) {
        let order = item
       
        self.collectedLabel.text    =   order.collectionFrom
        self.statusLabel.text       =   "\(order.status)"
        self.deliveryLabel.text     =   order.deliveryFrom
        self.priceLabel.text        =   String(format: "%@ %.2f", order.price, "Currency".localized())
            
        selectionStyle              =   .none
    }
}
