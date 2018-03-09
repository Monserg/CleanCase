//
//  OrderItemsTableViewFooterView.swift
//  CleanCase
//
//  Created by msm72 on 15.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//

import UIKit
import SKStyleKit

class OrderItemsTableViewFooterView: UITableViewHeaderFooterView {
    // MARK: - IBOutlets
    @IBOutlet weak var topView: UIView! {
        didSet {
            topView.isHidden = true
        }
    }
    
    @IBOutlet weak var priceView: UIView! {
        didSet {
            priceView.isHidden = true
        }
    }
    
    @IBOutlet var captionLabelsCollection: [SKLabel]! {
        didSet {
            _ = captionLabelsCollection.map({
                $0.text!.localize()
            })
        }
    }
    
    @IBOutlet weak var totalCaptionLabel: UILabel! {
        didSet {
            totalCaptionLabel.text!.localize()
            
        }
    }
    
    @IBOutlet weak var orderPriceLabel: UILabel!
    
    @IBOutlet weak var orderDeliveryDateLabel: UILabel! {
        didSet {
            orderDeliveryDateLabel.text             =   orderDeliveryDateLabel.text!.localized()
            orderDeliveryDateLabel.textAlignment    =   .center
            orderDeliveryDateLabel.isHidden         =   false
        }
    }
    
    
    // MARK: - Custom Functions
    func setup(withOrder order: Order) {
        switch order.orderStatus {
        // Type 3: Closed, Ready, Supplied, InWayToClient
        case 2, 3, 5, 8:
            self.topView.isHidden                   =   false
            self.priceView.isHidden                 =   false
            self.orderPriceLabel.text               =   String(format: "%@ %.2f", "Currency".localized(), order.price)
            
            if let deliveryFrom = order.deliveryFrom, let deliveryTo = order.deliveryTo {
                self.orderDeliveryDateLabel.text    =   String(format: "%@ %@", deliveryFrom, deliveryTo)
            }
            
        default:
            self.topView.isHidden                   =   true
            self.priceView.isHidden                 =   true
        }
    }
}
