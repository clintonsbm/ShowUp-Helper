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
    func save(check: NSManagedObject)
    func appendSave(check: NSManagedObject)
    func showDatePicker(oldCheck: NSManagedObject, isCheckIn: Bool, type: DateReturnType)
}

class EditChecks: UIView {

    @IBOutlet var dayLbl: UILabel!
    @IBOutlet var weekNumber: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var totalDayLbl: UILabel!
    
    var updateCheckIn: Bool = true
    
    var dayChecks: [NSManagedObject] = []
    var willBeDeleted: [NSManagedObject] = []
    
    var newCheckInToBeSaved: NSManagedObject?
    
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
            if self.willBeSaved.count >= 1 || self.newCheckInToBeSaved != nil {
                let alert = UIAlertController(title: "Discart changes", message: "You really want to discart your changes?", preferredStyle: .alert)
                
                let discart = UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
                    self.disappearOnBottom(in: superview)
                })
                
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                alert.addAction(discart)
                alert.addAction(cancel)
                
                self.editChecksDelegate.showAlertInController(alert: alert)
            } else {
                self.disappearOnBottom(in: superview)
            }
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
            cell.editChecksDelegate = self.editChecksDelegate
            cell.set(check: self.dayChecks[indexPath.row])
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: AddManualCheckTableViewCell.identifier) as! AddManualCheckTableViewCell
            
            if let firstCheck = self.dayChecks.first {
                cell.editRequestDelegate = self
                cell.set(firsCheck: firstCheck)
            }
            
            return cell
        }
    }
}

extension EditChecks: EditRequestDelegate {
    func save(check: NSManagedObject) {
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
        
        self.editChecksDelegate.updateTableView()
    }
    
    func appendSave(check: NSManagedObject) {
//        self.willBeSaved.append(check)
    }
    
    func showDatePicker(oldCheck: NSManagedObject, isCheckIn: Bool, type: DateReturnType = DateReturnType.selectCustomDate) {
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
        datePickerView.type = type
        
        if type == .checkInToNewDate {
            datePickerView.pickerTitle.text = "Select checkin time"
        } else if type == .checkOutToNewDate {
            datePickerView.pickerTitle.text = "Select checkout time"
        }
        
        self.addSubview(datePickerView)
        
        UIView.animate(withDuration: 0.5) {
            datePickerView.alpha = 1
        }
    }
}

extension EditChecks: DateSelectDelegate {
    func dateSelect(date: Date, to: DateReturnType) {
        UIView.animate(withDuration: 0.5, animations: {
            self.datePicker?.alpha = 0
        }) { (_) in
            self.datePicker?.removeFromSuperview()
            
            switch to {
            case .checkInDate:
                self.checkInOutDate(date: date)
            case .checkOutDate:
                self.checkInOutDate(date: date)
            case .checkInToNewDate:
                self.newCheckInToBeSaved = ChecksController().checkIn(with:date as NSDate, willSave: false)
                self.showDatePicker(oldCheck: self.newCheckInToBeSaved!, isCheckIn: true, type: .checkOutToNewDate)
            case .checkOutToNewDate:
                if let newCheckIn = self.newCheckInToBeSaved {
                    //Adds 1 sec, otherwise it will count the time interval with hh:mm:59
                    var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date as Date)
                    
                    components.second = (date as NSDate).second + 1
                    let newDate = Calendar.current.date(from: components)! as NSDate
                    
                    if let checkInAsDate = self.newCheckInToBeSaved?.value(forKey: ChecksController.checkInKey) as? NSDate {
                        if date.timeIntervalSince(checkInAsDate as Date) > 0 {
                            ChecksController().checkOut(with: newDate, withCheckIn: newCheckIn)
                            self.dayChecks.append(newCheckIn)
                            self.tableView.reloadData()
                        } else {
                            let alert = UIAlertController(title: "Back in time?", message: "The check out time should be after the check in time. Try again, your check in was on: \(checkInAsDate.hour.formatTwoCases()):\(checkInAsDate.minute.formatTwoCases())", preferredStyle: .alert)
                            
                            let discart = UIAlertAction(title: "Discart", style: .default, handler: { (action) in
                                self.showDatePicker(oldCheck: self.newCheckInToBeSaved!, isCheckIn: true, type: .checkOutToNewDate)
                            })
                            
                            alert.addAction(discart)
                            
                            self.editChecksDelegate.showAlertInController(alert: alert)
                        }
                    }
                }
            default:
                print("error DateReturnType: \(to)")
            }
        }
    }
    
    func checkInOutDate(date: Date) {
        var index = 0
        for check in self.dayChecks {
            if check == self.oldCheckToCompare {
                var checkAsDate: NSDate = NSDate()
                
                if self.updateCheckIn {
                    if let checkOutAsDate = check.value(forKey: ChecksController.checkOutKey) as? NSDate {
                        if checkOutAsDate.timeIntervalSince(date) < 0 {
                            let alert = UIAlertController(title: "Back in time?", message: "The check out time should be after the check in time.", preferredStyle: .alert)
                            
                            let discart = UIAlertAction(title: "Discart", style: .default, handler: { (action) in
                                ///show picker
                            })
                            
                            alert.addAction(discart)
                            
                            self.editChecksDelegate.showAlertInController(alert: alert)
                            
                            return
                        }
                    }
                } else {
                    if let checkInAsDate = check.value(forKey: ChecksController.checkInKey) as? NSDate {
                        if date.timeIntervalSince(checkInAsDate as Date) < 0 {
                            let alert = UIAlertController(title: "Back in time?", message: "The check out time should be after the check in time.", preferredStyle: .alert)
                            
                            let discart = UIAlertAction(title: "Discart", style: .default, handler: { (action) in
                                ///show picker
                            })
                            
                            alert.addAction(discart)
                            
                            self.editChecksDelegate.showAlertInController(alert: alert)
                            
                            return
                        }
                    }
                }
                
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
                        self.oldCheckToCompare?.setValue(newDate as NSDate, forKey: ChecksController.checkInKey)
                        cell.updateAmount(checkIn: newDate, checkOut: self.oldCheckToCompare?.value(forKey: ChecksController.checkOutKey) as! NSDate)
                    } else {
                        cell.checkOutBtn.setTitle("\(newDate.hour.formatTwoCases()):\(newDate.minute.formatTwoCases())", for: .normal)
                        self.oldCheckToCompare?.setValue(newDate as NSDate, forKey: ChecksController.checkOutKey)
                        cell.updateAmount(checkIn: self.oldCheckToCompare?.value(forKey: ChecksController.checkInKey) as! NSDate, checkOut: newDate)
                    }
                }
            }
            index += 1
        }
    }
    
//    func checkInToNewDate(object: NSManagedObject, newDate: Date) {
//        if let checkAsDate = object.value(forKey: ChecksController.checkInKey) as? NSDate {
//            print(object)
//            var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: checkAsDate as Date)
//
//            components.hour = (newDate as NSDate).hour
//            components.minute = (newDate as NSDate).minute
//            components.second = (newDate as NSDate).second
//
//            object.setValue(Calendar.current.date(from: components)! as NSDate, forKey: ChecksController.checkInKey)
//            print(object)
//        }
//    }
    
    func cancelDateSelection() {
        UIView.animate(withDuration: 0.5, animations: {
            self.datePicker?.alpha = 0
        }) { (_) in
            self.datePicker?.removeFromSuperview()
        }
    }
    
}
