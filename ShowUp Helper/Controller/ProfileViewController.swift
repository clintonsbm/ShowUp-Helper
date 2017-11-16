//
//  ProfileViewController.swift
//  ShowUp Helper
//
//  Created by Clinton de Sá Barreto Maciel on 09/11/2017.
//  Copyright © 2017 Clinton Barreto. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var userNameLbl: UILabel!
    @IBOutlet var logoutBtn: UIButton!
    
    @IBOutlet var changeQRCodeBackView: UIView!
    @IBOutlet var resetWorkingHoursBackView: UIView!
    @IBOutlet var logOutBackView: UIView!
    
    let imagePicker: UIImagePickerController = UIImagePickerController()
    
    var isProfileChanging: Bool = true
    var showTextField: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        self.setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func changeQRCode(_ sender: UIButton) {
        self.isProfileChanging = false
        self.selectImage()
    }
    
    @IBAction func resetWorkingHours(_ sender: UIButton) {
        let alert = UIAlertController(title: "CAUTION", message: "Do you really want to reset all the working hours? It's irreversible", preferredStyle: .alert)
        
        let reset = UIAlertAction(title: "Reset", style: .destructive) { (action) in
            ChecksController().resetDatabase()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(reset)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func logOut(_ sender: UIButton) {
        if sender.titleLabel?.text == "Log in" {
            self.isProfileChanging = true
            self.selectImage()
        } else {
            UserDefaults().saveProfileImage(image: #imageLiteral(resourceName: "emptyStateProfile"))
            self.logoutBtn.setTitle("Log in", for: .normal)
            self.userNameLbl.text = "Doge Noname"
            self.logoutBtn.backgroundColor = UIColor(red: 68/255, green: 219/255, blue: 94/255, alpha: 1)
        }
    }
    
    @IBAction func showEditProfileOptions(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let changeProfilePictureAction = UIAlertAction(title: "Change Profile Picture", style: .default) { (_) in
            self.isProfileChanging = true
            self.showTextField = false
            self.selectImage()
        }
        
        let removeProfilePictureAction = UIAlertAction(title: "Remove Profile Picture", style: .destructive) { (_) in
            self.profileImageView.image = #imageLiteral(resourceName: "emptyStateProfile")
            UserDefaults().saveProfileImage(image: #imageLiteral(resourceName: "emptyStateProfile"))
        }
        
        let changeProfileNameAction = UIAlertAction(title: "Change Profile Name", style: .default) { (_) in
            let alert = UIAlertController(title: "Profile name", message: nil, preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.placeholder = "Doge Noname"
            }
            
            let done = UIAlertAction(title: "Done", style: .cancel) { (action) in
                let textField = alert.textFields?.first!
                
                if textField?.text?.count != 0 {
                    self.userNameLbl.text = textField?.text
                }
            }
            
            alert.addAction(done)
            
            self.present(alert, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(changeProfilePictureAction)
        alert.addAction(removeProfilePictureAction)
        alert.addAction(changeProfileNameAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func selectImage() {
        self.imagePicker.allowsEditing = false
        self.imagePicker.sourceType = .photoLibrary
        
        self.imagePicker.delegate = self
        
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    func setupView() {
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.height/2
        self.changeQRCodeBackView.dropShadow()
        self.resetWorkingHoursBackView.dropShadow()
        self.logOutBackView.dropShadow()
        
        self.profileImageView.image = UserDefaults().retriveProfileImage()
        
//        if self.profileImageView.image == #imageLiteral(resourceName: "emptyStateProfile") {
//            self.isProfileChanging = true
//            let selectImageGesture = UITapGestureRecognizer(target: self, action: #selector(self.selectImage))
//
//            self.profileImageView.isUserInteractionEnabled = true
//            self.profileImageView.addGestureRecognizer(selectImageGesture)
//        }
    }

}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            if self.isProfileChanging {
                self.profileImageView.image = pickedImage
                
                self.profileImageView.gestureRecognizers?.removeAll()
                
                UserDefaults().saveProfileImage(image: pickedImage)
                
                picker.dismiss(animated: true, completion: nil)
                
                //Show alert with textfield to get name
                if self.showTextField {
                    let alert = UIAlertController(title: "Profile name", message: nil, preferredStyle: .alert)
                    alert.addTextField { (textField) in
                        textField.placeholder = "Doge Noname"
                    }
                    
                    let done = UIAlertAction(title: "Done", style: .cancel) { (action) in
                        let textField = alert.textFields?.first!
                        
                        if textField?.text?.count != 0 {
                            self.userNameLbl.text = textField?.text
                            self.logoutBtn.setTitle("Log out", for: .normal)
                            self.logoutBtn.backgroundColor = UIColor(red: 255/255, green: 38/255, blue: 0/255, alpha: 1)
                        } else {
                            ///Não ta mudando a foto
                            self.profileImageView.image = #imageLiteral(resourceName: "emptyStateProfile")
                        }
                    }
                    alert.addAction(done)
                    
                    self.present(alert, animated: true, completion: nil)
                }
                self.showTextField = true
            } else {
                
                UserDefaults().saveQRImage(image: pickedImage)
                self.isProfileChanging = true
                picker.dismiss(animated: true, completion: nil)
            }            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
