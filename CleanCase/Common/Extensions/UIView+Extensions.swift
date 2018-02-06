//
//  UIView+Extensions.swift
//  CleanCase
//
//  Created by msm72 on 06.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//

import UIKit

extension UIView {
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation               =   CATransition()
        animation.timingFunction    =   CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.type              =   kCATransitionFade
        animation.duration          =   duration
        
        layer.add(animation, forKey: kCATransitionFade)
    }
}
