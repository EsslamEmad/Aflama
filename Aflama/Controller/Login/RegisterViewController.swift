//
//  RegisterViewController.swift
//  Aflama
//
//  Created by Esslam Emad on 25/2/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import SVProgressHUD
import RZTransitions
import PromiseKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var nameTextField: TextField!
    @IBOutlet weak var emailTextField: TextField!
    @IBOutlet weak var phoneTextField: TextField!
    @IBOutlet weak var passwordTextField: TextField!
    @IBOutlet weak var passwordConfirmationTextField: TextField!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerButton.layer.cornerRadius = 5.0
        registerButton.clipsToBounds = true
    }
    

    @IBAction func didPressRegister(_ sender: Any) {
        guard let name = nameTextField.text, name != "", let email = emailTextField.text, email.isEmail(), let phone = phoneTextField.text, phone != "", let password = passwordTextField.text, password != "", let password2 = passwordConfirmationTextField.text, password2 != "" else {
            self.showAlert(withMessage: NSLocalizedString("من فضلك أدخل جميع بياناتك لتسجيل حساب جديد", comment: ""))
            return
        }
        guard password == password2 else {
            self.showAlert(withMessage: NSLocalizedString("كلمة المرور غير متطابقة", comment: ""))
            return
        }
        var user = User()
        user.name = name
        user.email = email
        user.phone = phone
        user.password = password
        user.type = 1
        
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.register(user: user))
            }.done {
                Auth.auth.user = try! JSONDecoder().decode(User.self, from: $0)
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
    }
    
    @IBAction func didPressBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
