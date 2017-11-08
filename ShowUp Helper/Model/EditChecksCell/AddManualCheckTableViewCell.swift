//
//  AddManualCheckTableViewCell.swift
//  ShowUp Helper
//
//  Created by Clinton de Sá Barreto Maciel on 07/11/2017.
//  Copyright © 2017 Clinton Barreto. All rights reserved.
//

import UIKit
import CoreData

class AddManualCheckTableViewCell: UITableViewCell {
    
    static let identifier = "AddManualCheckTableViewCell"
    
    var editRequestDelegate: EditRequestDelegate? = nil
    var firstCheckOfTable: NSManagedObject? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }
    
    func set(firsCheck: NSManagedObject) {
        self.firstCheckOfTable = firsCheck
    }

    override func setSelected(_ selected: Bool, animated: Bool) {        
        if selected {
            if let _ = self.firstCheckOfTable {
                self.editRequestDelegate?.showDatePicker(oldCheck: self.firstCheckOfTable!, isCheckIn: true, type: .checkInToNewDate)
            }
        }
    }
}
