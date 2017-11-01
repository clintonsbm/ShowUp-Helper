//
//  HistoryViewController.swift
//  ShowUp Helper
//
//  Created by Clinton de Sá Barreto Maciel on 10/10/2017.
//  Copyright © 2017 Clinton Barreto. All rights reserved.
//

import UIKit
import CoreData

protocol DateSelectDelegate {
    func dateSelect(date: Date)
    func cancelDateSelection()
}

class HistoryViewController: UIViewController {

    @IBOutlet var weekView: CheckInOutRange!
    @IBOutlet var tabbleView: UITableView!
    @IBOutlet var upButton: UIBarButtonItem!
    @IBOutlet var downButton: UIBarButtonItem!
    @IBOutlet var yearButton: UIBarButtonItem!
    
    let checksController = ChecksController()
    
    var baseDate = NSDate()
    
    var dictionaryOfChecks: [Int : [Int : [NSManagedObject]]] = [:]
    
    var willShowDatePicker = true
    var datePicker: DatePickerHolder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        
        self.tabbleView.register(UINib(nibName: "WeekResumeCellXib", bundle: nil), forCellReuseIdentifier: WeekResumeCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.dictionaryOfChecks = self.formatDatabaseFor(date: self.baseDate)
        self.tabbleView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func formatDatabaseFor(date: NSDate) -> [Int : [Int : [NSManagedObject]]] {
        
        let arrayOfChecks = self.checksController.getAllChecks(printResults: false)
        
        let arrayFilteredByMonth = arrayOfChecks.filter { ($0?.value(forKey: self.checksController.checkOutKey) as? NSDate)?.year == date.year /*&& ($0?.value(forKey: self.checksController.checkOutKey) as? NSDate)?.monthInt == date.monthInt */} as? [NSManagedObject]
        
        var weekDictionary: [Int: [NSManagedObject]] = [:]
        if let _ = arrayFilteredByMonth {
            
            for check in arrayFilteredByMonth! {
            
                let checkAsDate = check.value(forKey: self.checksController.checkOutKey) as! NSDate
                
                if weekDictionary[checkAsDate.weekOfYear] == nil {
                    weekDictionary[checkAsDate.weekOfYear] = [check]
                } else {
                    weekDictionary[checkAsDate.weekOfYear]?.append(check)
                }
            }
        }
        
        var weekAndDayDictionary: [Int : [Int : [NSManagedObject]]] = [:]
        for week in weekDictionary {
            
            for day in (0...6) {
                
                let filteredChecks = week.value.filter({ (check) -> Bool in
                    (check.value(forKey: self.checksController.checkInKey) as! NSDate).dayInWeek == day
                })
                
                if filteredChecks.count != 0 {
                    if weekAndDayDictionary[week.key] == nil {
                        weekAndDayDictionary[week.key] = [:]
                        
                        weekAndDayDictionary[week.key]![day] = filteredChecks
                    } else {
                        
                        weekAndDayDictionary[week.key]![day] = filteredChecks
                    }
                }
            }
        }
        
        return weekAndDayDictionary
    }
    
    func numberOfWeekKey(section: Int) -> Int? {
        var keysArray: [Int] = []
        
        for key in self.dictionaryOfChecks.keys {
            keysArray.append(key)
        }
        
        keysArray = keysArray.sorted()
        
        if keysArray.count > section {
            return keysArray[section]
        }
        
        return nil
    }
    
    func numberOfDayKey(week: Int, row: Int) -> Int? {
        var keysArray: [Int] = []
        
        if let week = self.dictionaryOfChecks[week] {
            for key in week.keys {
                keysArray.append(key)
            }
        }
        
        keysArray = keysArray.sorted()
        
        if keysArray.count > row {
            return keysArray[row]
        }
        
        return nil
    }
    
    @IBAction func upWeek(_ sender: UIButton) {
        
        if let newDate = BaseDateHandler.addWeekIn(date: self.baseDate) {
            self.baseDate = newDate
            
            self.updateFixedDateLabels()
            
            self.dictionaryOfChecks = self.formatDatabaseFor(date: self.baseDate)
            
            self.tabbleView.reloadData()
        }
    }
    
    @IBAction func downWeek(_ sender: UIButton) {
        
        if let newDate = BaseDateHandler.removeWeekIn(date: self.baseDate) {
            self.baseDate = newDate
            
            self.updateFixedDateLabels()
            
            self.dictionaryOfChecks = self.formatDatabaseFor(date: self.baseDate)
            
            self.tabbleView.reloadData()
        }
    }
    
    @IBAction func customDateSelect(_ sender: UIButton) {
        
        if self.willShowDatePicker {
            self.fadeInAndAddDatePicker()
            self.willShowDatePicker = !self.willShowDatePicker
        } else {
            self.fadeOutAndAddDatePicker()
            self.willShowDatePicker = !self.willShowDatePicker
        }
    }
    
    func updateFixedDateLabels() {
        self.weekView.set(firstEntered: self.baseDate)
        self.title = self.baseDate.month
        self.yearButton.title = self.baseDate.year
    }
    
    func fadeInAndAddDatePicker() {
        
        let datePickerView = DatePickerHolder.createPicker()
        self.datePicker = datePickerView
        
        datePickerView.dateSelectDelegate = self
        
        datePickerView.frame.size.width = self.view.frame.width
        datePickerView.frame.size.height = 3*self.view.frame.height/7
        datePickerView.frame.origin.y = self.view.frame.height
        
        self.view.addSubview(datePickerView)

//        self.view.needsUpdateConstraints()
//        self.view.updateConstraints()
        
        self.datePicker?.appearFromBottom(in: self.view)
    }
    
    func fadeOutAndAddDatePicker() {
        self.datePicker?.disappearOnBottom(in: self.view)
    }
    
    func setupView() {
        self.updateFixedDateLabels()
        
        self.yearButton.customView?.layer.cornerRadius = 5
        self.yearButton.customView?.layer.borderWidth = 1
        self.yearButton.customView?.layer.borderColor = UIColor.black.cgColor
    }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let week = self.dictionaryOfChecks[self.baseDate.weekOfYear] {
            return week.keys.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let weekKey = self.baseDate.weekOfYear
        if let keyOfDay = self.numberOfDayKey(week: weekKey, row: section) {
            if let count = self.dictionaryOfChecks[weekKey]?[keyOfDay]?.count {
                if section == (self.dictionaryOfChecks[self.baseDate.weekOfYear]?.keys.count)! - 1 {
                    return count + 2
                }
                
                return count + 1
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let keyOfWeek = self.baseDate.weekOfYear
            
            if let keyOfDay = self.numberOfDayKey(week: keyOfWeek, row: indexPath.section) {
                
                if indexPath.row == (self.dictionaryOfChecks[keyOfWeek]?[keyOfDay]?.count)! {
                    //Last cell - total time
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.totalTime.rawValue)! as! TotalTimeTableViewCell
                    
                    if let managedObjects = self.dictionaryOfChecks[keyOfWeek]?[keyOfDay] {
                        
                        cell.set(managedObjects: managedObjects)
                    }
                    
                    return cell
                } else if (indexPath.section == (self.dictionaryOfChecks[self.baseDate.weekOfYear]?.keys.count)! - 1) && (indexPath.row == (self.dictionaryOfChecks[keyOfWeek]?[keyOfDay]?.count)! + 1) {
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: WeekResumeCell.identifier) as! WeekResumeCell
                    
                    var arrayOfWeekChecks: [NSManagedObject] = []
                    
                    for day in self.dictionaryOfChecks[keyOfWeek]! {
                        for check in day.value {
                            arrayOfWeekChecks.append(check)
                        }
                    }
                    
                    cell.set(weekChecks: arrayOfWeekChecks)
                    
                    return cell
                } else {
                   
                    let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.labelsStructureAndTime.rawValue)! as! LabelsStructureAndTimeTimeTableViewCell
                    
                    let checkInDate = self.dictionaryOfChecks[keyOfWeek]?[keyOfDay]?[indexPath.row].value(forKey: self.checksController.checkInKey) as! NSDate
                    let checkOutDate = self.dictionaryOfChecks[keyOfWeek]?[keyOfDay]?[indexPath.row].value(forKey: self.checksController.checkOutKey) as! NSDate
                    
                    cell.set(entered: checkInDate, exited: checkOutDate)
                    
                    return cell
                }
            }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

         let keyOfWeek = self.baseDate.weekOfYear
            if let keyOfDay = self.numberOfDayKey(week: keyOfWeek, row: section) {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.dayOfWeek.rawValue) as! DayOfWeekTableViewCell
                
                let firstDate = self.dictionaryOfChecks[keyOfWeek]?[keyOfDay]?.first?.value(forKey: self.checksController.checkOutKey) as! NSDate
                
                cell.set(firstDate: firstDate)
                
                return cell
            }
        
        
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 74
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 69
    }
}

extension HistoryViewController: DateSelectDelegate {
    func dateSelect(date: Date) {
        self.view.fadeOut()
        
        self.baseDate = date as NSDate
        
        self.updateFixedDateLabels()
        self.dictionaryOfChecks = self.formatDatabaseFor(date: self.baseDate)
        self.tabbleView.reloadData()
        
        self.willShowDatePicker = !self.willShowDatePicker
    }
    
    func cancelDateSelection() {
        self.fadeOutAndAddDatePicker()
        
        self.willShowDatePicker = !self.willShowDatePicker
    }
}




































