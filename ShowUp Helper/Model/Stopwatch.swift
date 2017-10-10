//
//  Stopwatch.swift
//  ShowUp Helper
//
//  Created by Clinton de Sá Barreto Maciel on 09/10/2017.
//  Copyright © 2017 Clinton Barreto. All rights reserved.
//

import UIKit

class Stopwatch: NSObject {
    
    weak var timer: Timer?
    var startTime: Double = 0
    var time: Double = 0
    var elapsed: Double = 0
    
    var updateLabelsDelegate: UpdateLabelsDelegate?
    
    func startStopwatch() {
        self.startTime = Date().timeIntervalSinceReferenceDate - self.elapsed
        self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    func stopStopwatch() {
        self.elapsed = Date().timeIntervalSinceReferenceDate - self.startTime
        self.timer?.invalidate()
        
        // Calculate total time since timer started in seconds
        self.time = Date().timeIntervalSinceReferenceDate - self.startTime
        
        // Calculate minutes
        let hours = Int(self.time / 3600.0)
        self.time -= (TimeInterval(hours) * 3600.0)
        
        let minutes = Int(self.time / 60.0)
        self.time -= (TimeInterval(minutes) * 60)
        
        // Calculate seconds
        let seconds = Int(self.time.rounded())
        self.time -= TimeInterval(seconds)
        
        // Format time vars with leading zero
        let strHours = String(format: "%02d", hours)
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        
        self.startTime = 0
        self.time = 0
        self.elapsed = 0
        
//        print("end time: \(strHours):\(strMinutes):\(strSeconds)")
        
//        self.updateLabelsDelegate?.stopStopwatch(time: (hours, minutes, seconds))
    }
    
    @objc func updateCounter() {
        
        // Calculate total time since timer started in seconds
        self.time = Date().timeIntervalSinceReferenceDate - self.startTime
        
        // Calculate minutes
        let hours = Int(self.time / 3600.0)
        time -= (TimeInterval(hours) * 3600.0)
        
        let minutes = Int(self.time / 60.0)
        self.time -= (TimeInterval(minutes) * 60)

        // Calculate seconds
        let seconds = Int(self.time.rounded())
        self.time -= TimeInterval(seconds)

        // Format time vars with leading zero
        let strHours = String(format: "%02d", hours)
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        
//        print("\(strHours):\(strMinutes):\(strSeconds)")
        
        self.updateLabelsDelegate?.updateStopwatch(time: (hours, minutes, seconds))
    }
}
