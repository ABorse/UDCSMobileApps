//
//  LoginViewController.swift
//  TextInAndOut
//
//  Created by aborse on 10/24/17.
//  Copyright © 2017 aborse. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let username = UserDefaults.standard.string(forKey: "username") {
            nameTextField.text = username
        }
    }
    
    @IBAction func goButtonTapped(_ sender: Any) {
        print(nameTextField.text ?? "no name")
        print(passwordTextField.text ?? "no pw")
        
        UserDefaults.standard.set(nameTextField.text ?? "", forKey: "username")
        UserDefaults.standard.synchronize()
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            passwordTextField.becomeFirstResponder()
        }
        if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
        }
        return true
    }
    
}
