//
//  ChecksController.swift
//  ShowUp Helper
//
//  Created by Clinton de Sá Barreto Maciel on 06/10/2017.
//  Copyright © 2017 Clinton Barreto. All rights reserved.
//

import UIKit
import CoreData

class ChecksController: NSObject {
    
    var entity: NSEntityDescription?
    
    private let entityName = "CheckIO"
    let checkInKey = "checkIn"
    let checkOutKey = "checkOut"
    
    var timer: Timer?
    var checkInDate: NSDate?
    
    var updateLabelsDelegate: UpdateLabelsDelegate?
    
    func syncTimer() {
        if let lastCheck = self.getAllChecks(printResults: false).last {
            if UserDefaults().isWorking() {
                if let lastCheckIn = lastCheck?.value(forKey: self.checkInKey) {
                    self.checkInDate = (lastCheckIn as! NSDate)
                    
                    self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
                }
            }
        }
    }
    
    func checkIn() {
        let date = NSDate()
        
        self.checkInDate = date
        
        UserDefaults().saveCheckIn(date: date)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext

        let entity = NSEntityDescription.entity(forEntityName: self.entityName, in: managedContext)!
        
        let checkIn = NSManagedObject(entity: entity, insertInto: managedContext)
        
        checkIn.setValue(date, forKeyPath: self.checkInKey)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func checkOut() {
        let date = NSDate()
        
        UserDefaults().saveCheckIn(date: date)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: self.entityName)
        
        do {
            let allSavedData = try managedContext.fetch(fetchRequest)
            allSavedData.last?.setValue(date, forKey: self.checkOutKey)
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        self.timer?.invalidate()
        self.finalizeTimer()
    }
    
    func getAllChecks(printResults: Bool) -> [NSManagedObject?] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return []
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: self.entityName)
        
        do {
            let allSavedData = try managedContext.fetch(fetchRequest)
            
            if printResults {
                for check in allSavedData {
                    print("\(String(describing: check.value(forKey: self.checkInKey))) and \(String(describing: check.value(forKey: self.checkOutKey)))")
                }
            }
            
            return allSavedData
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return []
    }
    
    func getHoursWorkedToday() -> (Int, Int, Int) {
        let allChecks = self.getAllChecks(printResults: false)
        
        var timeInterval: Double = 0
        
        for check in allChecks {
            
            if let checkOut = (check?.value(forKey: self.checkOutKey) as? Date) {
            
                if Calendar.current.isDateInToday(checkOut) {
                    timeInterval += (check?.value(forKey: self.checkOutKey) as! Date).timeIntervalSince((check?.value(forKey: self.checkInKey) as! Date))
                }
            }
        }
        
        // Calculate minutes
        let hours = Int(timeInterval / 3600.0)
        timeInterval -= (TimeInterval(hours) * 3600.0)
        
        let minutes = Int(timeInterval / 60.0)
        timeInterval -= (TimeInterval(minutes) * 60)
        
        // Calculate seconds
        let seconds = Int(timeInterval)
        timeInterval -= TimeInterval(seconds)
        
        return (hours, minutes, seconds)
    }
    
    @objc func updateTimer() {
        if let date = self.checkInDate {
            var timeElapsed = Date().timeIntervalSince(date as Date)
            
            // Calculate minutes
            let hours = Int(timeElapsed / 3600.0)
            timeElapsed -= (TimeInterval(hours) * 3600.0)
            
            let minutes = Int(timeElapsed / 60.0)
            timeElapsed -= (TimeInterval(minutes) * 60)
            
            // Calculate seconds
            let seconds = Int(timeElapsed.rounded())
            timeElapsed -= TimeInterval(seconds)
            
            self.updateLabelsDelegate?.updateStopwatch(time: (hours, minutes, seconds))
        }
    }
    
    func finalizeTimer() {
        if let lastCheck = self.getAllChecks(printResults: false).last {
            if let lastCheckOut = lastCheck?.value(forKey: self.checkOutKey) {
                
                self.updateLabelsDelegate?.stopStopwatch()
            }
        }
    }
    
    func resetDatabase() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedContext.execute(deleteRequest)
        } catch let error as NSError {
            print("Could not delete all data. \(error), \(error.userInfo)")
        }
    }
}
