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
    
    @IBOutlet var totalTimeLabe: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func set(managedObjects: [NSManagedObject]) {
        let checkController = ChecksController()
        
        var totalTime: Int = 0
        
        for check in managedObjects {
            totalTime += Int((check.value(forKey: checkController.checkOutKey) as! NSDate).timeIntervalSince(((check.value(forKey: checkController.checkInKey) as! NSDate) as Date)))
        }
        
        let formatedTime: (h: String, m: String, s: String) = totalTime.formatSecToHMS()
        
        if formatedTime.h == "00" && formatedTime.m == "00" {
            self.totalTimeLabe.text = "\(formatedTime.s) sec"
        } else {
            self.totalTimeLabe.text = "\(formatedTime.h):\(formatedTime.m)"
        }
    }
}
