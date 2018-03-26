//
//  GCDBlackBox.swift
//
//  Created by Jarrod Parkes on 11/3/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async(execute: {
        updates()
    })
}

func performTasksOnAsyncAfter(nanoseconds time: Double, _ tasks: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + dispatchTimeDelay * time) {
        tasks()
    }
}
