//
//  TotalTimeTableViewCell.swift
//  ShowUp Helper
//
//  Created by Clinton de Sá Barreto Maciel on 17/10/2017.
//  Copyright © 2017 Clinton Barreto. All rights reserved.
//

import UIKit
import CoreData

class TotalTimeTableViewCell: UITableViewCell {
    
    @IBOutlet var totalTImeLabe: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(managedObjects: [NSManagedObject]) {
        let checkController = ChecksController()
        
        var totalTime: Double = 0
        
        for check in managedObjects {
            totalTime += (check.value(forKey: checkController.checkOutKey) as! NSDate).timeIntervalSince(((check.value(forKey: checkController.checkInKey) as! NSDate) as Date))
        }
        
        let formatedTime: (h: String, m: String, s: String) = totalTime.formatSecToHMS()
        
        self.totalTImeLabe.text = "\(formatedTime.h):\(formatedTime.m)"
    }

}
