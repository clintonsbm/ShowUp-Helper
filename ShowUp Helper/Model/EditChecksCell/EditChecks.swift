//
//  EditChecks.swift
//  ShowUp Helper
//
//  Created by Clinton de Sá Barreto Maciel on 07/11/2017.
//  Copyright © 2017 Clinton Barreto. All rights reserved.
//

import UIKit
import CoreData

protocol EditRequestDelegate {
    func appendDelete(check: NSManagedObject)
    func appendSave(check: NSManagedObject)
    func showDatePicker(oldCheck: NSManagedObject, isCheckIn: Bool)
}

class EditChecks: UIView {

    @IBOutlet var dayLbl: UILabel!
    @IBOutlet var weekNumber: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var totalDayLbl: UILabel!
    
    var updateCheckIn: Bool = true
    
    var dayChecks: [NSManagedObject] = []
    
    var willBeDeleted: [NSManagedObject] = []
    
    ///The date with a array of tuples. The boolean confirms is the date is a checkin. If false, is a checkout.
    var willBeSaved: [NSManagedObject : [(isChecking: Bool, newDate: NSDate)]] = [:]
    
    var oldCheckToCompare: NSManagedObject?
    
    var datePicker: DatePickerHolder?
    
    var editChecksDelegate: EditChecksDelegate!
    
    static func createView() -> EditChecks {
        let editChecks = UINib(nibName: "EditChecksXib", bundle: nil)
        let editChecksView = editChecks.instantiate(withOwner: self, options: nil)[0] as! UIView
                
        return editChecksView as! EditChecks
    }

    @IBAction func save(_ sender: UIButton) {
        for check in self.willBeSaved {
            for tuples in check.value {
                if tuples.isChecking {
                    check.key.setValue(tuples.newDate, forKey: ChecksController.checkInKey)
                } else {
                    check.key.setValue(tuples.newDate, forKey: ChecksController.checkOutKey)
                }
            }
        }
        
        for check in self.willBeDeleted {
            ChecksController.delete(check: check)
        }
        
        if let superview = self.superview {
            self.editChecksDelegate.updateTableView()
            ChecksController.save()
            self.disappearOnBottom(in: superview)
        }
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        if let superview = self.superview {
            self.disappearOnBottom(in: superview)
        }
    }
}

extension EditChecks: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dayChecks.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row != self.dayChecks.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: EditChecksCell.identifier) as! EditChecksCell
            
            cell.editRequestDelegate = self
            cell.set(check: self.dayChecks[indexPath.row])
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: AddManualCheckTableViewCell.identifier) as! AddManualCheckTableViewCell
            
            return cell
        }
    }
}

extension EditChecks: EditRequestDelegate {
    func appendDelete(check: NSManagedObject) {
        self.willBeDeleted.append(check)
        
        var totalTime: Int = 0
        for currentCheck in self.dayChecks {
            if check != currentCheck {
                totalTime += Int((currentCheck.value(forKey: ChecksController.checkOutKey) as! NSDate).timeIntervalSince(((currentCheck.value(forKey: ChecksController.checkInKey) as! NSDate) as Date)))
            }
        }
        
        let time: (h: String, m: String, s: String) = totalTime.formatSecToHMS()
        
        if time.h == "00" && time.m == "00" {
            self.totalDayLbl.text = "\(time.s) sec"
        } else {
            self.totalDayLbl.text = "\(time.h):\(time.m)"
        }
    }
    
    func appendSave(check: NSManagedObject) {
//        self.willBeSaved.append(check)
    }
    
    func showDatePicker(oldCheck: NSManagedObject, isCheckIn: Bool) {
        self.updateCheckIn = isCheckIn
        self.oldCheckToCompare = oldCheck
        
        let datePickerView = DatePickerHolder.createPicker()
        self.datePicker = datePickerView
        
        datePickerView.frame.size.width = self.frame.width
        datePickerView.frame.size.height = 3*self.frame.height/7
        datePickerView.frame.origin.y = self.frame.height/2
        datePickerView.alpha = 0
        
        datePickerView.datePicker.datePickerMode = .time
        datePickerView.datePicker.timeZone = TimeZone.current
        datePickerView.datePicker.calendar = Calendar.current
        
        if isCheckIn {
            datePickerView.datePicker.date = (self.oldCheckToCompare?.value(forKey: ChecksController.checkInKey) as? Date)!
        } else {
            datePickerView.datePicker.date = (self.oldCheckToCompare?.value(forKey: ChecksController.checkOutKey) as? Date)!
        }
        
        datePickerView.dateSelectDelegate = self
        
        self.addSubview(datePickerView)
        
        UIView.animate(withDuration: 0.5) {
            datePickerView.alpha = 1
        }
    }
}

extension EditChecks: DateSelectDelegate {
    func dateSelect(date: Date) {
        UIView.animate(withDuration: 0.5, animations: {
            self.datePicker?.alpha = 0
        }) { (_) in
            self.datePicker?.removeFromSuperview()
            
            var index = 0
            for check in self.dayChecks {
                if check == self.oldCheckToCompare {
                    var checkAsDate: NSDate = NSDate()
                    
                    if self.updateCheckIn {
                        if let checkInDate = self.oldCheckToCompare?.value(forKey: ChecksController.checkInKey) as? NSDate {
                            checkAsDate = checkInDate
                        }
                    } else {
                        if let checkOutDate = self.oldCheckToCompare?.value(forKey: ChecksController.checkOutKey) as? NSDate {
                            checkAsDate = checkOutDate
                        }
                    }
                    
                    var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: checkAsDate as Date)
                    
                    components.hour = (date as NSDate).hour
                    components.minute = (date as NSDate).minute
                    components.second = (date as NSDate).second
                    
                    let newDate = Calendar.current.date(from: components)! as NSDate
                    
                    if self.updateCheckIn {
                        if let _ = self.oldCheckToCompare {
                            if self.willBeSaved[self.oldCheckToCompare!] == nil {
                                self.willBeSaved[self.oldCheckToCompare!] = []
                                self.willBeSaved[self.oldCheckToCompare!]?.append((true, newDate))
                            } else {
                                self.willBeSaved[self.oldCheckToCompare!]?.append((false, newDate))
                            }
                        }
                    } else {
                        if let _ = self.oldCheckToCompare {
                            if self.willBeSaved[self.oldCheckToCompare!] == nil {
                                self.willBeSaved[self.oldCheckToCompare!] = []
                                self.willBeSaved[self.oldCheckToCompare!]?.append((false, newDate))
                            } else {
                                self.willBeSaved[self.oldCheckToCompare!]?.append((false, newDate))
                            }
                        }
                    }
                    
                    if let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? EditChecksCell {
                        if self.updateCheckIn {
                            cell.checkInBtn.setTitle("\(newDate.hour.formatTwoCases()):\(newDate.minute.formatTwoCases())", for: .normal)
                            cell.updateAmount(checkIn: newDate, checkOut: self.oldCheckToCompare?.value(forKey: ChecksController.checkOutKey) as! NSDate)
                        } else {
                            cell.checkOutBtn.setTitle("\(newDate.hour.formatTwoCases()):\(newDate.minute.formatTwoCases())", for: .normal)
                            cell.updateAmount(checkIn: self.oldCheckToCompare?.value(forKey: ChecksController.checkOutKey) as! NSDate, checkOut: newDate)
                        }
                    }
                }
                index += 1
            }
        }
    }
    
    func cancelDateSelection() {
        UIView.animate(withDuration: 0.5, animations: {
            self.datePicker?.alpha = 0
        }) { (_) in
            self.datePicker?.removeFromSuperview()
        }
    }
    
}
