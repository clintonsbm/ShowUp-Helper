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
    
    var arrayOfChecks: [Int: [NSManagedObject]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.arrayOfChecks = self.formatDatabaseFor(date: self.baseDate)
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
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrayOfChecks.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let count = self.arrayOfChecks[section]?.count {
            return count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            //First cell - week from to
        } else if indexPath.row == 1 {
            //Second cell - day of week
        } else if indexPath.row == 2{
            //Fourth cell - time labels structure
        } else if indexPath.row + 1 == self.arrayOfChecks[indexPath.section]?.count {
            //Last cell - total time
        } else {
            
        }
    }
}
