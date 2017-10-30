//
//  IntExtension.swift
//  ShowUp Helper
//
//  Created by Clinton de Sá Barreto Maciel on 20/10/2017.
//  Copyright © 2017 Clinton Barreto. All rights reserved.
//

import Foundation

extension Int {
    func formatTwoCases() -> String {
        return String(format: "%02d", self)
    }
    
    func formatSecToHMS() -> (h: String, m: String, s: String) {
        var totalTime: Int = self
        
        let hours = Int(totalTime / 3600)
        totalTime -= Int(TimeInterval(hours) * 3600)
        
        let minutes = Int(totalTime / 60)
        totalTime -= Int(TimeInterval(minutes) * 60)
        
        let seconds = Int(totalTime)
        
        return (h: hours.formatTwoCases(), m: minutes.formatTwoCases(), s: seconds.formatTwoCases())
    }
}
