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
        
        let enteredHours = String(format: "%02d", entered.hour)
        let enteredMinutes = String(format: "%02d", entered.minute)
        
        self.enteredLabel.text = "\(enteredHours):\(enteredMinutes) \(emoji)"
        
        let exitedHours = String(format: "%02d", entered.hour)
        let exitedMinutes = String(format: "%02d", entered.minute)
        
        self.exitedLabel.text = "\(emoji) \(exitedHours):\(exitedMinutes)"
        
        var timeInterval: Double = 0
        
        timeInterval = exited.timeIntervalSince(entered as Date)
        
        if timeInterval <= 59 {
            let seconds = Int(timeInterval)
            let formatedSeconds = String(format: "%02d", seconds)
            
            self.amountLabel.text = "\(formatedSeconds) sec"
        } else {
            
            // Calculate minutes
            let hours = Int(timeInterval / 3600.0)
            timeInterval -= (TimeInterval(hours) * 3600.0)
            
            let minutes = Int(timeInterval / 60.0)
            timeInterval -= (TimeInterval(minutes) * 60)
            
            let formatedHours = String(format: "%02d", hours)
            let formatedMinutes = String(format: "%02d", minutes)
            
            self.amountLabel.text = "\(formatedHours):\(formatedMinutes)"
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
