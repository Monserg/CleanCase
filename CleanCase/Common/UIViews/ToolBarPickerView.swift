//
//  ToolBarPickerView.swift
//  CleanCase
//
//  Created by msm72 on 07.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//

import UIKit

class ToolBarPickerView: UIPickerView {
    // MARK: - Properties
    var items: [PickerViewSupport]?

    
    // MARK: - Class Initialization
    init(withFrame frame: CGRect, andItems items: [PickerViewSupport]) {
        super.init(frame: frame)
        
        self.items              =   items
        self.backgroundColor    =   UIColor.lightGray
        self.dataSource         =   self
        self.delegate           =   self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


// MARK: - UIPickerViewDataSource
extension ToolBarPickerView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items?.count ?? 0
    }
}


// MARK: - UIPickerViewDelegate
extension ToolBarPickerView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return frame.width
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 34.0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items![row].title
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        self.txt_pickUpData.text = items[row]
    }
}
