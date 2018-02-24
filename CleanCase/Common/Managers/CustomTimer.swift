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
    var seconds: Int

    private lazy var timer: DispatchSourceTimer = {
        let t = DispatchSource.makeTimerSource()
        t.schedule(deadline: .now() + 3, repeating: .seconds(6))
        t.setEventHandler(handler: { [weak self] in
            self?.eventHandler?()
        })
        
        return t
    }()
    
    var eventHandler: (() -> Void)?
    
    private enum State {
        case suspended
        case resumed
    }
    
    private var state: State = .suspended
    
    
    // MARK: - Class Initialization
    init(withSecondsInterval seconds: Int) {
        self.seconds = seconds
    }
    
    convenience init() {
        self.init(withSecondsInterval: 0)
    }

    deinit {
        timer.setEventHandler {}
        timer.cancel()
        resume()
        eventHandler = nil
    }
    
    func resume() {
        if state == .resumed {
            return
        }
        
        state = .resumed
        timer.resume()
    }
    
    func suspend() {
        if state == .suspended {
            return
        }
        
        state = .suspended
        timer.suspend()
    }
}
