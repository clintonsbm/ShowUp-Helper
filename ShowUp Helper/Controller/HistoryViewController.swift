//
//  HistoryViewController.swift
//  ShowUp Helper
//
//  Created by Clinton de Sá Barreto Maciel on 10/10/2017.
//  Copyright © 2017 Clinton Barreto. All rights reserved.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController {

    let checksController = ChecksController()
    
    var baseDate = NSDate()
    
    var dictionaryOfChecks: [Int: [NSManagedObject]] = [:]
    
    @IBOutlet var tabbleView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabbleView.register(UINib(nibName: "CheckInOutRangeViewXib", bundle: nil), forHeaderFooterViewReuseIdentifier: CheckInOutRangeHeader.identifier)
        
        self.tabbleView.register(UINib(nibName: "MonthResumeXib", bundle: nil), forCellReuseIdentifier: MonthResumeCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.dictionaryOfChecks = self.formatDatabaseFor(date: self.baseDate)
        
        self.tabbleView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func formatDatabaseFor(date: NSDate) -> [Int: [NSManagedObject]] {
        
        let arrayOfChecks = self.checksController.getAllChecks(printResults: true)
        
        let arrayFilteredByMonth = arrayOfChecks.filter { ($0?.value(forKey: self.checksController.checkOutKey) as? NSDate)?.year == date.year && ($0?.value(forKey: self.checksController.checkOutKey) as? NSDate)?.monthInt == date.monthInt } as? [NSManagedObject]
        
        
        var weekDictionary: [Int: [NSManagedObject]] = [:]
        
        if let _ = arrayFilteredByMonth {
            
            for check in arrayFilteredByMonth! {
            
                let checkAsDate = check.value(forKey: self.checksController.checkOutKey) as! NSDate
                
                if weekDictionary[checkAsDate.weekOfMonth] == nil {
                    weekDictionary[checkAsDate.weekOfMonth] = [check]
                } else {
                    weekDictionary[checkAsDate.weekOfMonth]?.append(check)
                }
            }
        
            for key in weekDictionary {
                for check in key.value {
                    print("\(String(describing: check.value(forKey: self.checksController.checkInKey)))  -  \(String(describing: check.value(forKey: self.checksController.checkOutKey)))")
                }
            }
        }
        
        return weekDictionary
    }
    
    func arrayOfKeys(index: Int) -> Int {
        var keysArray: [Int] = []
        
        for key in self.dictionaryOfChecks.keys {
            keysArray.append(key)
        }
        
        keysArray = keysArray.sorted()
        
        return keysArray[index]
    }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dictionaryOfChecks.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let keyOfSection = self.arrayOfKeys(index: section)
        
        if let count = self.dictionaryOfChecks[keyOfSection]?.count {
            //Number of checks in a day plus the 3 ones of structure (dayOfWeek, totalTime)
            return count + 3
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let keyOfSection = self.arrayOfKeys(index: indexPath.section)
        
        let firstDate = self.dictionaryOfChecks[keyOfSection]?.first?.value(forKey: self.checksController.checkInKey) as! NSDate
        
        let referenceRow = indexPath.row - 1  //Minus 1 rows in structure, the last one is not considered
        
         if indexPath.row == 0 {
            //Second cell - day of week
            
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.dayOfWeek.rawValue)! as! DayOfWeekTableViewCell
            
            cell.set(firstDate: firstDate)
            
            return cell
        } else if indexPath.row == (self.dictionaryOfChecks[keyOfSection]?.count)! + 1 {
            //Last cell - total time
            
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.totalTime.rawValue)! as! TotalTimeTableViewCell
            
            if let managedObjects = self.dictionaryOfChecks[keyOfSection] {
                
                cell.set(managedObjects: managedObjects)
            }
            
            return cell
        }
         else if indexPath.row == (self.dictionaryOfChecks[keyOfSection]?.count)! + 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: MonthResumeCell.identifier)!
            // as! MonthResumeFooter
            
            //        let keyOfSection = self.arrayOfKeys(index: section)
            
            //        print("Section: \(section) || Week: \(keyOfSection) || First date: \(firstDate)")
            
            //        cell.set(firstEntered: firstDate)
            
            return cell
         } else {
            print(indexPath.row)
            print(referenceRow)
            
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.labelsStructureAndTime.rawValue)! as! LabelsStructureAndTimeTimeTableViewCell
            
            let checkInDate = self.dictionaryOfChecks[keyOfSection]?[referenceRow].value(forKey: self.checksController.checkInKey) as! NSDate
            let checkOutDate = self.dictionaryOfChecks[keyOfSection]?[referenceRow].value(forKey: self.checksController.checkOutKey) as! NSDate
            
            cell.set(entered: checkInDate, exited: checkOutDate)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: CheckInOutRangeHeader.identifier) as! CheckInOutRangeHeader
        
        let keyOfSection = self.arrayOfKeys(index: section)
        
        let firstDate = self.dictionaryOfChecks[keyOfSection]?.first?.value(forKey: self.checksController.checkOutKey) as! NSDate
        
        print("Section: \(section) || Week: \(keyOfSection) || First date: \(firstDate)")
        
        cell.set(firstEntered: firstDate)
        
        return cell
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







































