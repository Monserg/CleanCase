//
//  OrderItemsTableViewFooterView.swift
//  CleanCase
//
//  Created by msm72 on 15.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//

import UIKit

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
    
    @IBOutlet var captionLabelsCollection: [UILabel]! {
        didSet {
            _ = captionLabelsCollection.map({
                $0.text!.localize()
                $0.textAlignment = .right
            })
        }
    }
    
    @IBOutlet weak var totalCaptionLabel: UILabel! {
        didSet {
            totalCaptionLabel.text = totalCaptionLabel.text!.localized()
            
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
    func setup(withOrderStatus orderStatus: Int16) {
        switch orderStatus {
        // Type 3: Closed, Ready, InWayToClient
        case 2, 3, 8:
            self.topView.isHidden                   =   false
            self.priceView.isHidden                 =   false
            self.orderDeliveryDateLabel.isHidden    =   false

        default:
            break
        }
    }
}
