//
//  MonthResumeFooter.swift
//  ShowUp Helper
//
//  Created by Clinton de Sá Barreto Maciel on 19/10/2017.
//  Copyright © 2017 Clinton Barreto. All rights reserved.
//

import UIKit
import CoreData

class WeekResumeCell: UITableViewCell {

    @IBOutlet var totalTimeMorning: UILabel!
    @IBOutlet var totalTimeAfternoon: UILabel!
    @IBOutlet var totalTimeWeek: UILabel!
    
    @IBOutlet var checkMorning: UILabel!
    @IBOutlet var checkAfternoon: UILabel!
    @IBOutlet var checkTimeWeek: UILabel!
    
    static let identifier = "WeekResumeCellXib"
    
    private var minimalTimeMorning: Int {
        return UserDefaults().retrieveMinimal(minimalCase: .morning)
    }
    
    private var minimalTimeAfternoon: Int {
        return UserDefaults().retrieveMinimal(minimalCase: .afternoon)
    }
    
    private var minimalTime: Int {
        return UserDefaults().retrieveMinimal(minimalCase: .week)
    }
    
    var totalMorning: Double = 0
    var totalAfternoon: Double = 0
    
    private let emojiTrue = "✅"
    private let emojiFalse = "⚠️"
    
    override func awakeFromNib() {
        self.selectionStyle = .none
    }

    func set(weekChecks: [NSManagedObject]) {
        let totalTimeMorning = self.calculateTotalTimeMorning(weekChecks: weekChecks)
        let totalTimeAfternoon = self.calculateTotalTimeAfternoon(weekChecks: weekChecks)
        
        let totalTimeMorningHMS: (h: String, m: String, s: String) = totalTimeMorning.formatSecToHMS()
        let totalTimeAfternoonHMS: (h: String, m: String, s: String) = totalTimeAfternoon.formatSecToHMS()
        let totalTime: (h: String, m: String, s: String) = (totalTimeMorning + totalTimeAfternoon).formatSecToHMS()
        
        if (totalTimeMorningHMS.h == "00") && (totalTimeMorningHMS.m == "00") {
            self.totalTimeMorning.text = "\(totalTimeMorningHMS.s) sec"
        } else {
            self.totalTimeMorning.text = "\(totalTimeMorningHMS.h):\(totalTimeMorningHMS.m)"
        }
        
        if (totalTimeAfternoonHMS.h == "00") && (totalTimeAfternoonHMS.m == "00") {
            self.totalTimeAfternoon.text = "\(totalTimeAfternoonHMS.s) sec"
        } else {
            self.totalTimeAfternoon.text = "\(totalTimeAfternoonHMS.h):\(totalTimeAfternoonHMS.m)"
        }
        
        if (totalTimeAfternoonHMS.h == "00") && (totalTimeAfternoonHMS.m == "00") {
            self.totalTimeAfternoon.text = "\(totalTimeAfternoonHMS.s) sec"
        } else {
            self.totalTimeAfternoon.text = "\(totalTimeAfternoonHMS.h):\(totalTimeAfternoonHMS.m)"
        }
        
        if (totalTime.h == "00") && (totalTime.m == "00") {
            self.totalTimeWeek.text = "\(totalTime.s) sec"
        } else {
            self.totalTimeWeek.text = "\(totalTime.h):\(totalTime.m)"
        }
        
        if totalTimeMorning >= self.minimalTimeMorning {
            self.checkMorning.text = self.emojiTrue
        } else {
            self.checkMorning.text = self.emojiFalse
        }
        
        if totalTimeAfternoon >= self.minimalTimeAfternoon {
            self.checkAfternoon.text = self.emojiTrue
        } else {
            self.checkAfternoon.text = self.emojiFalse
        }
        
        if totalTimeMorning + totalTimeAfternoon >= self.minimalTime {
            self.checkTimeWeek.text = self.emojiTrue
        } else {
            self.checkTimeWeek.text = self.emojiFalse
        }
    }
    
    func calculateTotalTimeMorning(weekChecks: [NSManagedObject]) -> Int {
        let checksController = ChecksController()
        var totalTimeMorning: Int = 0
        
        for check in weekChecks {
            if let checkIn = check.value(forKey: checksController.checkInKey) as? NSDate {
                if let checkOut = check.value(forKey: checksController.checkOutKey) as? NSDate {
                    
                    var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: checkIn as Date)
                    
                    components.hour = 13
                    components.minute = 0
                    components.second = 0
                    
                    let afternoonShift = Calendar.current.date(from: components)!
                    
                    if checkIn.hour < 13 {
                        if checkOut.hour < 13 {
                            totalTimeMorning += Int(checkOut.timeIntervalSince(checkIn as Date))
                        } else {
                            totalTimeMorning += Int(afternoonShift.timeIntervalSince(checkIn as Date))
                        }
                    }
                }
            }
        }
        
        return totalTimeMorning
    }
    
    func calculateTotalTimeAfternoon(weekChecks: [NSManagedObject]) -> Int {
        let checksController = ChecksController()
        var totalTimeAfternoon: Int = 0
        
        for check in weekChecks {
            if let checkIn = check.value(forKey: checksController.checkInKey) as? NSDate {
                if let checkOut = check.value(forKey: checksController.checkOutKey) as? NSDate {
                    
                    var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: checkOut as Date)
                    
                    components.hour = 13
                    components.minute = 0
                    components.second = 0
                    
                    let afternoonShift = Calendar.current.date(from: components)!
                    
                    if checkIn.hour >= 13 {
                        totalTimeAfternoon += Int(checkOut.timeIntervalSince(checkIn as Date))
                    } else if checkOut.hour >= 13 {
                        totalTimeAfternoon += Int(checkOut.timeIntervalSince(afternoonShift))
                    }
                }
            }
        }
        
        return totalTimeAfternoon
    }
}
