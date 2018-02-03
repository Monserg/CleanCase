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
    
    @IBOutlet weak var laundryLabel: UILabel!
    
    
    // MARK: - Class Initialization
    init(withName name: String) {
        super.init(frame: CGRect.init(origin: .zero, size: CGSize.init(width: 100, height: 44)))
        
        createFromXIB()
        laundryLabel.text = name
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
}
