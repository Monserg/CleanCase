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
extension OrderTableViewCell: ConfigureCell {
    func setup(withItem item: Any, andIndexPath indexPath: IndexPath) {
        let order = item as! OrdersShowModels.OrderItem.RequestModel.DisplayedOrder
       
        self.collectedLabel.text    =   order.createdDate + " " + order.collectionFrom
        self.statusLabel.text       =   OrderStatus(rawValue: order.status)!.name
        self.deliveryLabel.text     =   order.deliveryFrom
        self.priceLabel.text        =   String(format: "%@ %.2f", order.price, "Currency".localized())
            
        selectionStyle              =   .none
    }
}
