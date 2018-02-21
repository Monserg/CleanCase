//
//  LaundryView.swift
//  CleanCase
//
//  Created by msm72 on 03.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//

import UIKit

class LaundryView: UIView {
    // MARK: - IBOutlets
    @IBOutlet var view: UIView! {
        didSet {
            view.backgroundColor = UIColor.clear
        }
    }
    
    @IBOutlet weak var laundryNameLabel: UILabel!
    @IBOutlet weak var laundryPhoneButton: UIButton!
    
    
    // MARK: - Class Initialization
    init(withName name: String, andPhoneNumber phoneNumber: String?) {
        super.init(frame: CGRect.init(origin: .zero, size: CGSize.init(width: 280.0 * widthRatio, height: 44)))
        
        createFromXIB()
        laundryNameLabel.text = name.localized()
        
        if let phone = phoneNumber {
            laundryPhoneButton.setTitle(phone, for: .normal)
        }
        
        else {
            laundryPhoneButton.isHidden = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createFromXIB()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        createFromXIB()
    }
    
    
    // MARK: - Class Functions
    func createFromXIB() {
        UINib(nibName: String(describing: LaundryView.self), bundle: Bundle(for: LaundryView.self)).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = frame
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 280.0 * widthRatio, height: 44)
    }
    
    
    // MARK: - Actions
    @IBAction func handlerLaundryPhoneButtonTapped(_ sender: UIButton) {
        guard let numberURL = URL(string: "tel://" + (sender.titleLabel?.text)!) else { return }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(numberURL)
        }
        
        else {
            UIApplication.shared.openURL(numberURL)
        }
    }    
}
