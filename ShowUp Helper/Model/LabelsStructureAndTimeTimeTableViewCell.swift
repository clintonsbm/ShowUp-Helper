//
//  LabelsStructureAndTimeTimeTableViewCell.swift
//  ShowUp Helper
//
//  Created by Clinton de Sá Barreto Maciel on 17/10/2017.
//  Copyright © 2017 Clinton Barreto. All rights reserved.
//

import UIKit

class LabelsStructureAndTimeTimeTableViewCell: UITableViewCell {

    @IBOutlet var enteredLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var exitedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func set(entered: NSDate, exited: NSDate) {
        
        var emoji: String = ""
        
        if exited.hour >= 13 {
            emoji = "🌗"
        } else {
            emoji = "☀️"
        }
        
        self.enteredLabel.text = "\(entered.hour.formatTwoCases()):\(entered.minute.formatTwoCases())"
        
        self.exitedLabel.text = "\(exited.hour.formatTwoCases()):\(exited.minute.formatTwoCases())"
        
        var timeInterval: Double = 0
        
        timeInterval = exited.timeIntervalSince(entered as Date)
        
        if timeInterval <= 59 {
            let seconds = Int(timeInterval)
            
            self.amountLabel.text = "\(seconds.formatTwoCases()) sec"
        } else {
            
            let formatedTime: (h: String, m: String, s: String) = timeInterval.formatSecToHMS()
            
            self.amountLabel.text = "\(formatedTime.h):\(formatedTime.m)"
        }
        
    }
}
