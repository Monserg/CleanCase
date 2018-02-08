//
//  OrdersControlViewController.swift
//  CleanCase
//
//  Created by msm72 on 08.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//

import UIKit

class OrdersControlViewController: UIViewController {
    // MARK: - Properties
    var handlerPassButtonTagCompletion: HandlerPassDataCompletion?
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var createOrderView: UIView! {
        didSet {
            createOrderView.isHidden = false
        }
    }
    
    @IBOutlet weak var myOrderView: UIView! {
        didSet {
            
        }
    }
    
    @IBOutlet weak var createOrderButton: UIButton! {
        didSet {
            
        }
    }
    
    @IBOutlet weak var myOrderButton: UIButton! {
        didSet {
            
        }
    }
    
    @IBOutlet var orderButtonsHeightConstraintsCollection: [NSLayoutConstraint]! {
        didSet {
            _ = orderButtonsHeightConstraintsCollection.map({ $0.constant *= heightRatio })
        }
    }
    
    @IBOutlet var orderButtonsWidthConstraintsCollection: [NSLayoutConstraint]! {
        didSet {
            _ = orderButtonsWidthConstraintsCollection.map({ $0.constant *= widthRatio })
        }
    }

    
    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    // MARK: - Custom Functions
    
    
    // MARK: - Actions
    @IBAction func handlerOrderButtonTapped(_ sender: UIButton) {
        handlerPassButtonTagCompletion!(sender.tag)
    }
    
    
    // FIXME: - DELETE AFTER TEST
    @IBAction func handlerPopoverButtonTapped(_ sender: Any) {
        self.createPopover(withName: "AgreementShow")
    }
    
    @IBAction func handlerOnboardButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "OnboardShowSegue", sender: nil)
    }
}
