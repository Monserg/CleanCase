//
//  CustomTimer.swift
//  CleanCase
//
//  Created by msm72 on 21.02.18.
//  Copyright © 2018 msm72. All rights reserved.
//

import Foundation

class CustomTimer {
    // MARK: - Properties
    var timer = Timer()
    var timeInterval: TimeInterval
    
    var handlerTimerActionCompletion: HandlerPassDataCompletion?
    
    
    // MARK: - Class Initialization
    init(withTimeInterval timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }
    
    convenience init() {
        self.init(withTimeInterval: 0.0)
    }
    
    
    // MARK: - Class Functions
    func start() {
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval:     self.timeInterval,
                                              target:           self,
                                              selector:         #selector(self.handlerAction),
                                              userInfo:         nil,
                                              repeats:          true)
        }
    }
    
    func stop() {
        timer.invalidate()
    }
    
    deinit {
        self.timer.invalidate()
    }
    
    
    // MARK: - Actions
    @objc func handlerAction() {
        handlerTimerActionCompletion!(nil)
    }
}
