//
//  EditProfileTableViewController.swift
//  Aflama
//
//  Created by Esslam Emad on 7/3/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import SVProgressHUD
import PromiseKit

class EditProfileTableViewController: UITableViewController, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate{
    
    var user = User()
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var sexTextField: UITextField!
    @IBOutlet weak var nationalityTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var tavelTextField: UITextField!
    @IBOutlet weak var aboutTextField: UITextField!
    @IBOutlet weak var attachmentsView: UIView!
    @IBOutlet weak var addPhotoImageView: UIImageView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    private let sexPicker = UIPickerView()
    private let travelPicker = UIPickerView()
    private let AgePicker = UIPickerView()
    private var inputAccessoryBar: UIToolbar!
    var ageArray = Array(13...80)
    var sexArray = [NSLocalizedString("ذكر", comment: ""), NSLocalizedString("أنثى", comment: "")]
    var travelArray = [NSLocalizedString("نعم", comment: ""), NSLocalizedString("لا", comment: "")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 1)
        let imageView = UIImageView(image: UIImage(named: "group_70"))
        imageView.contentMode = .scaleAspectFill
        tableView.backgroundView = imageView
        containerView.clipsToBounds = true
        sendButton.clipsToBounds = true
        containerView.layer.cornerRadius = 10.0
        sendButton.layer.cornerRadius = 10.0
        initializeToolbar()
        nameTextField.text = Auth.auth.user!.name
        emailTextField.text = Auth.auth.user!.email
        phoneTextField.text = Auth.auth.user!.phone
        if Auth.auth.user!.about != nil, Auth.auth.user!.about != "", Auth.auth.user!.about != "0" {
            cityTextField.text = Auth.auth.user!.city
            countryTextField.text = Auth.auth.user!.country
            nationalityTextField.text = Auth.auth.user!.nationality
            aboutTextField.text = Auth.auth.user!.about
            sexTextField.text = sexArray[Auth.auth.user!.gender - 1]
            tavelTextField.text = travelArray[Auth.auth.user!.travel - 1]
            ageTextField.text = String(Auth.auth.user!.age)
            user.gender = Auth.auth.user!.gender
            user.age = Auth.auth.user!.age
            user.travel = Auth.auth.user!.travel
        }

    }
    
    
    @IBAction func didPressSend(_ sender: Any) {
        guard let name = nameTextField.text, name != "", let email = emailTextField.text, email != "", let phone  = phoneTextField.text, phone != "", user.age != nil, user.gender != nil, user.travel != nil, let nationality = nationalityTextField.text, nationality != "", let country = countryTextField.text, country != "", let city = cityTextField.text, city != "", let about = aboutTextField.text, about != "", ImagePicked else {
            self.showAlert(withMessage: NSLocalizedString("من فضلك أدخل جميع بياناتك .", comment: ""))
            return
        }
        user.idForEdit = Auth.auth.user!.id
        user.name = name
        user.email = email
        user.phone = phone
        user.country = country
        user.city = city
        user.nationality = nationality
        user.about = about
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.upload(image: addPhotoImageView.image, file: nil, video: nil))
            }.done {
                let resp = try! JSONDecoder().decode(UploadResponse.self, from: $0)
                self.user.photo = resp.image
                firstly{
                    return API.CallApi(APIRequests.editUser(user: self.user))
                    }.done {
                        Auth.auth.user! = try! JSONDecoder().decode(User.self, from: $0)
                        self.performMainSegue()
                    }.catch {
                        self.showAlert(withMessage: $0.localizedDescription)
                }
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
        
    }
    
    
    
    func performMainSegue(animated: Bool = true){
        guard let window = UIApplication.shared.keyWindow else { return }
        guard let rootViewController = window.rootViewController else { return }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainViewController")
        vc.view.frame = rootViewController.view.frame
        vc.view.layoutIfNeeded()
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = vc
        })
    }
    
   
    
    
    //Mark: Pickers
    
    
    
    private func initializePickers() {
        AgePicker.delegate = self
        AgePicker.dataSource = self
        ageTextField.inputView = AgePicker
        ageTextField.inputAccessoryView = inputAccessoryBar
        sexPicker.delegate = self
        sexPicker.dataSource = self
        sexTextField.inputView = sexPicker
        sexTextField.inputAccessoryView = inputAccessoryBar
        travelPicker.delegate = self
        travelPicker.dataSource = self
        tavelTextField.inputView = travelPicker
        tavelTextField.inputAccessoryView = inputAccessoryBar
    }
    
    private func initializeToolbar() {
        inputAccessoryBar = UIToolbar(frame: CGRect(x: 0, y:0, width: view.frame.width, height: 44))
        let doneButton = UIBarButtonItem(title: NSLocalizedString("تم", comment: ""), style: .done, target: self, action: #selector(dismissPicker))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        inputAccessoryBar.items = [flexibleSpace, doneButton]
        initializePickers()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView{
        case sexPicker:
            return sexArray.count
        case AgePicker:
            return ageArray.count
        case travelPicker:
            return travelArray.count
        
        default:
            return 5
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView{
        case AgePicker:
            return String(ageArray[row])
        case sexPicker:
            return sexArray[row]
        case travelPicker:
            return travelArray[row]
        
        default: return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView{
        case AgePicker:
            ageTextField.text = String(ageArray[row])
            user.age = ageArray[row]
        case sexPicker:
            sexTextField.text = sexArray[row]
            user.gender = row + 1
        case travelPicker:
            tavelTextField.text = travelArray[row]
            user.travel = row + 1
        
        default: return
        }
        
    }
    
    @objc func dismissPicker() {
        view.endEditing(true)
    }
    
    
    //Mark: Image and video Picker
    
    @IBAction func PickImage(recognizer: UITapGestureRecognizer) {
        
        let alert = UIAlertController(title: "", message: NSLocalizedString("اختر طريقة رفع الصورة.", comment: ""), preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: NSLocalizedString("الكاميرا", comment: ""), style: .default, handler: {(UIAlertAction) -> Void in
            SVProgressHUD.show()
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.allowsEditing = false
                picker.sourceType = .camera
                self.present(picker, animated: true, completion: {() -> Void in SVProgressHUD.dismiss()})
            }
            else{
                SVProgressHUD.dismiss()
                self.showAlert(withMessage: NSLocalizedString("التطبيق لا يستطيع الوصول إلى الكاميرا الخاصة بك", comment: ""))
            }
        })
        let photoAction = UIAlertAction(title: NSLocalizedString("مكتبة الصور", comment: ""), style: .default, handler: {(UIAlertAction) -> Void in
            SVProgressHUD.show()
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.allowsEditing = false
                picker.sourceType = .photoLibrary
                self.present(picker, animated: true, completion: {() -> Void in SVProgressHUD.dismiss()})
            }
            else{
                SVProgressHUD.dismiss()
                self.showAlert(withMessage: NSLocalizedString("التطبيق لا يستطيع الوصول إلى مكتبة الصور الخاصة بك", comment: ""))
            }
        })
        let cancelAction = UIAlertAction(title: NSLocalizedString("إلغاء", comment: ""), style: .cancel, handler: nil)
        
        alert.addAction(cameraAction)
        alert.addAction(photoAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    var ImagePicked = false
    var videoPicked = false
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let infoimg = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        if let selectedImage = infoimg[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage{
            addPhotoImageView.image = selectedImage
            addPhotoImageView.contentMode = .scaleAspectFill
            ImagePicked = true
        }
            
        
        dismiss(animated: true, completion: nil)
    }
    
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
