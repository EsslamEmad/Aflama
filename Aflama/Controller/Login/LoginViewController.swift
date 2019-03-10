//
//  LoginViewController.swift
//  Aflama
//
//  Created by Esslam Emad on 25/2/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import SVProgressHUD
import PromiseKit
import RZTransitions

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: TextField!
    @IBOutlet weak var passwordTextField: TextField!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signInButton.layer.cornerRadius = 5.0
        signInButton.clipsToBounds = true
    }
    

    @IBAction func didPressLogin(_ sender: Any) {
        
        guard let email = emailTextField.text, email.isEmail(), let password = passwordTextField.text, password != "" else {
            self.showAlert(withMessage: NSLocalizedString("من فضلك أدخل بيانات تسجيل الدخول", comment: ""))
            return
        }
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.login(email: email, password: password))
            }.done {
                Auth.auth.user = try! JSONDecoder().decode(User.self, from: $0)
                self.performMainSegue()
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
        
    }
    
    @IBAction func didPressForgotPassword(_ sender: Any) {
        let alert = UIAlertController(title: "", message: NSLocalizedString("من فضلك أدخل بريدك الإلكتروني..", comment: ""), preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = NSLocalizedString("البريد الإلكتروني", comment: "")
        }
        let resetPasswordAction = UIAlertAction(title: NSLocalizedString("إستعادة كلمة المرور", comment: ""), style: .default, handler: { (UIAlertAction) in
            if let textField = alert.textFields?.first{
                guard let email = textField.text, email != "", email.isEmail() else {
                    self.showAlert(error: true, withMessage: NSLocalizedString("من فضلك أدخل بريدك الإلكتروني!", comment: ""), completion: nil)
                    return
                }
                SVProgressHUD.show()
                firstly{
                    return API.CallApi(APIRequests.forgotPassword(email: textField.text!))
                    }.done {
                        let resp = try! JSONDecoder().decode(ResponseMessage.self, from: $0)
                        self.showAlert(error: false, withMessage: resp.message, completion: nil)
                    }.catch {
                        self.showAlert(withMessage: $0.localizedDescription)
                    }.finally {
                        SVProgressHUD.dismiss()
                }
                
            }
        })
        let cancelAction = UIAlertAction(title: NSLocalizedString("إلغاء", comment: ""), style: .cancel, handler: nil)
        alert.addAction(resetPasswordAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func performMainSegue(animated: Bool = true){
        guard let window = UIApplication.shared.keyWindow else { return }
        guard let rootViewController = window.rootViewController else { return }
        self.dismiss(animated: true, completion: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainViewController")
        vc.view.frame = rootViewController.view.frame
        vc.view.layoutIfNeeded()
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = vc
        })
    }
    
}
