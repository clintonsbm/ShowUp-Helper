//
//  DayOfWeekTableViewCell.swift
//  ShowUp Helper
//
//  Created by Clinton de Sá Barreto Maciel on 17/10/2017.
//  Copyright © 2017 Clinton Barreto. All rights reserved.
//

import UIKit

class DayOfWeekTableViewCell: UITableViewCell {

    @IBOutlet var dayOfWeek: UILabel!
    @IBOutlet var dayNumber: UILabel!
    
    @IBOutlet var editButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.editButton.isEnabled = false
    }
    
    func set(firstDate: NSDate) {
        self.dayOfWeek.text = firstDate.dayOfWeek
        
        self.dayNumber.text = "Day: \(firstDate.day.formatTwoCases())"
        
        editButton.layer.cornerRadius = 5
        editButton.layer.borderWidth = 1
        editButton.layer.borderColor = UIColor.black.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
