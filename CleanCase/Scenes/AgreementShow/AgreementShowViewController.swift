//
//  AgreementShowViewController.swift
//  CleanCase
//
//  Created by msm72 on 05.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//

import UIKit

class AgreementShowViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text!.localize()
            titleLabel.numberOfLines = 1
            titleLabel.textAlignment = .right
        }
    }

    @IBOutlet weak var captionLabel: UILabel! {
        didSet {
            captionLabel.text!.localize()
            captionLabel.numberOfLines = 0
            captionLabel.textAlignment = .left
        }
    }

    @IBOutlet weak var contentLabel: UILabel! {
        didSet {
            contentLabel.text!.localize()
            contentLabel.numberOfLines = 0
            contentLabel.textAlignment = .right
        }
    }
    
    @IBOutlet var colorViewsCollection: [UIView]!
    
    
    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Gestures
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if (touch.view == self.view) {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    
    // MARK: - Actions
    @IBAction func handlerCancelButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
