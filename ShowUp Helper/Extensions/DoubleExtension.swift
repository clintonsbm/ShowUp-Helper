//
//  DoubleExtension.swift
//  ShowUp Helper
//
//  Created by Clinton de Sá Barreto Maciel on 20/10/2017.
//  Copyright © 2017 Clinton Barreto. All rights reserved.
//

import Foundation

extension Double {
    func formatSecToHMS() -> (h: String, m: String, s: String) {
        var totalTime: Double = self
        
        let hours = Int(totalTime / 3600.0)
        totalTime -= (TimeInterval(hours) * 3600.0)
        
        let minutes = Int(totalTime / 60.0)
        totalTime -= (TimeInterval(minutes) * 60)
        
        let seconds = totalTime
        
        let formatedHours = String(format: "%02d", hours)
        let formatedMinutes = String(format: "%02d", minutes)
        let formatedSeconds = String(format: "%02d", seconds)
        
        return (h: formatedHours, m: formatedMinutes, s: formatedSeconds)
    }
}
