//
//  QRViewController.swift
//  ShowUp Helper
//
//  Created by Clinton de Sá Barreto Maciel on 04/10/2017.
//  Copyright © 2017 Clinton Barreto. All rights reserved.
//

import UIKit
import CoreData

protocol UpdateLabelsDelegate {
    func updateStopwatch(time: (h: Int, m: Int, s:Int))
    func stopStopwatch()
}

class QRViewController: UIViewController {

    @IBOutlet var qrCodeImageView: UIImageView!
    @IBOutlet var backgroundQRCodeImageView: UIView!
    
    @IBOutlet var checkButton: UIButton!
    @IBOutlet var backgroundCheckButton: UIView!
    
    @IBOutlet var elapsedTimeLbl: UILabel!
    @IBOutlet var backgroundTimeLbl: UIView!
    
    @IBOutlet var dayTimeLbl: UILabel!
    @IBOutlet var backgroundDayTimeLbl: UIView!
    
    @IBOutlet var monthWeekDayLbl: UILabel!
    
    let imagePicker = UIImagePickerController()
    
    let checkController: ChecksController = ChecksController()
    
    var startDate: NSDate?
    
    let emptyStateQRCode = "emptyStateQRCode"
    
    var totalOfDay: (h: Int, m: Int, s: Int) = (0, 0, 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePicker.delegate = self

        self.checkController.updateLabelsDelegate = self
        self.checkController.syncTimer()
        
        self.totalOfDay = self.checkController.getHoursWorkedToday()
        
        self.setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func selectImage() {
        
        self.imagePicker.allowsEditing = false
        self.imagePicker.sourceType = .photoLibrary
        
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func checkButtonClicked(_ sender: UIButton) {
        if self.qrCodeImageView.image != UIImage(named: self.emptyStateQRCode)! {
            
            UserDefaults().invertCheck(checkController: self.checkController)
            
            let labelAndColor: (label: String, color: UIColor) = UserDefaults().getCheckLabelAnColor()
            
            self.checkButton.setTitle(labelAndColor.label, for: .normal)
            self.backgroundCheckButton.backgroundColor = labelAndColor.color
        } else {
            
            //Shows alert of blank QRCode
            print("Unable to check")
        }
    }
    
    func setupView() {
        
        self.backgroundQRCodeImageView.dropShadow()
        self.backgroundCheckButton.dropShadow()
        self.backgroundTimeLbl.dropShadow()
        self.backgroundDayTimeLbl.dropShadow()
        
        
        self.monthWeekDayLbl.text = "\(NSDate().month) • Week \(NSDate().weekOfMonth.formatTwoCases()) • \(NSDate().dayOfWeek)"
        
        let selectImageGesture = UITapGestureRecognizer(target: self, action: #selector(self.selectImage))
        
        self.qrCodeImageView.image = UserDefaults().retriveQRCode()
        
        if self.qrCodeImageView.image == UIImage(named: self.emptyStateQRCode)! {
            
            self.qrCodeImageView.isUserInteractionEnabled = true
            self.qrCodeImageView.addGestureRecognizer(selectImageGesture)
        }
        
        let labelAndColor: (label: String, color: UIColor) = UserDefaults().getCheckLabelAnColor()
        
        self.checkButton.setTitle(labelAndColor.label, for: .normal)
        self.backgroundCheckButton.backgroundColor = labelAndColor.color
        
        self.dayTimeLbl.text = "\(self.totalOfDay.h.formatTwoCases()):\(self.totalOfDay.m.formatTwoCases()):\(self.totalOfDay.s.formatTwoCases())"
    }
}

extension QRViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.qrCodeImageView.image = pickedImage
            
            self.qrCodeImageView.gestureRecognizers?.removeAll()
            
            UserDefaults().saveQRImage(image: pickedImage)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension QRViewController: UpdateLabelsDelegate {
    func updateStopwatch(time: (h: Int, m: Int, s: Int)) {
        
        self.elapsedTimeLbl.text = "\(time.h.formatTwoCases()):\(time.m.formatTwoCases()):\(time.s.formatTwoCases())"
    }
    
    func stopStopwatch() {
        let totalHoursDay: (h: Int, m: Int, s: Int) = self.checkController.getHoursWorkedToday()
        
        self.dayTimeLbl.text = "\(totalHoursDay.h.formatTwoCases()):\(totalHoursDay.m.formatTwoCases()):\(totalHoursDay.s.formatTwoCases())"
    }
}




















