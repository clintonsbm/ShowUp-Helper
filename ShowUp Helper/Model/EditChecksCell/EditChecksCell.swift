//
//  EditChecksCell.swift
//  ShowUp Helper
//
//  Created by Clinton de Sá Barreto Maciel on 07/11/2017.
//  Copyright © 2017 Clinton Barreto. All rights reserved.
//

import UIKit
import CoreData

class EditChecksCell: UITableViewCell {
    
    static let identifier = "EditCheckCell"

    @IBOutlet var checkInBtn: UIButton!
    @IBOutlet var timeIntervalLbl: UILabel!
    @IBOutlet var checkOutBtn: UIButton!
    
    var check: NSManagedObject?
    var editedCheck: NSManagedObject?
    
    var editRequestDelegate: EditRequestDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        self.checkInBtn.layer.cornerRadius = 5
        self.checkInBtn.layer.borderWidth = 1
        self.checkInBtn?.layer.borderColor = UIColor(red: 68/255, green: 219/255, blue: 94/255, alpha: 1).cgColor
        
        self.checkOutBtn?.layer.cornerRadius = 5
        self.checkOutBtn?.layer.borderWidth = 1
        self.checkOutBtn?.layer.borderColor = UIColor(red: 254/255, green: 56/255, blue: 36/255, alpha: 1).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func set(check: NSManagedObject) {
        self.check = check
        
        if let checkInAsDate = check.value(forKey: ChecksController.checkInKey) as? NSDate {
            if let checkOutAsDate = check.value(forKey: ChecksController.checkOutKey) as? NSDate{
                self.checkInBtn.setTitle("\(checkInAsDate.hour.formatTwoCases()):\(checkInAsDate.minute.formatTwoCases())", for: .normal)
                self.checkOutBtn.setTitle("\(checkOutAsDate.hour.formatTwoCases()):\(checkOutAsDate.minute.formatTwoCases())", for: .normal)
                
                self.updateAmount(checkIn: checkInAsDate, checkOut: checkOutAsDate)
            }
        }
    }
    
    func updateAmount(checkIn: NSDate, checkOut: NSDate) {
        
        let time = checkOut.timeIntervalSince(checkIn as Date).formatSecToHMS()
        
        if time.h == "00" && time.m == "00" {
            self.timeIntervalLbl.text = "\(time.s) sec"
        } else {
            self.timeIntervalLbl.text = "\(time.h):\(time.m)"
        }
    }
    
    @IBAction func editCheckIn(_ sender: UIButton) {
        if let _ = self.check {
            self.editRequestDelegate.showDatePicker(oldCheck: self.check!, isCheckIn: true)
        }
    }
    
    @IBAction func editCheckOut(_ sender: UIButton) {
        if let _ = self.check {
            self.editRequestDelegate.showDatePicker(oldCheck: self.check!, isCheckIn: false)
        }
    }
    
    @IBAction func deleteCheck(_ sender: UIButton) {
        if let _ = self.check {
            self.editRequestDelegate.appendDelete(check: self.check!)
            self.removeFromSuperview()
        }
    }
}
