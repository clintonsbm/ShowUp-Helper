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
    
    var firstDate: NSDate? = nil
    
    var editChecksDelegate: EditChecksDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.editButton.layer.cornerRadius = 5
        self.editButton.layer.borderWidth = 1
        self.editButton.layer.borderColor = UIColor.black.cgColor
    }
    
    func set(firstDate: NSDate) {
        self.firstDate = firstDate
        
        self.dayOfWeek.text = firstDate.dayOfWeek
        
        self.dayNumber.text = "Day: \(firstDate.day.formatTwoCases())"
    }

    @IBAction func editChecks(_ sender: UIButton) {
        if let _ = self.firstDate {
            self.editChecksDelegate?.callEditView(firstDate: self.firstDate!)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
