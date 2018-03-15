//
//  RegistrationViewController.swift
//  LoginSignup
//
//  Created by Vetaliy Poltavets on 3/13/18.
//  Copyright © 2018 vpoltave. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var errorLbl: UILabel!
    
    var user = User()
    
    /// MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        backgroundImage.clipsToBounds = true
        errorLbl.isHidden = true
        nameTextField.customTextField()
        emailTextField.customTextField()
        passwordTextField.customTextField()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        errorLbl.isHidden = true
        nameTextField.text = ""
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    /// MARK: - Actions
    @IBAction func signupPressed(_ sender: UIButton) {
        
        if !(nameTextField.text?.isEmpty)! && !(emailTextField.text?.isEmpty)! && !(passwordTextField.text?.isEmpty)! {
            user.name = nameTextField.text!
            user.email = emailTextField.text!
            user.password = passwordTextField.text!
            NetworkManager.registrationMethod(forUser: user, completion: { [weak self] (success, error) in
                guard let strongSelf = self else { return }
                if !success {
                    strongSelf.errorLbl.text = error
                    strongSelf.errorLbl.isHidden = false
                } else {
                    DispatchQueue.main.async {
//                        strongSelf.errorLbl.isHidden = true
                        strongSelf.performSegue(withIdentifier: "fromSignup", sender: self)
                    }
                }
            })
        } else {
            errorLbl.isHidden = false
            errorLbl.text = "Some fields are empty!"
        }
        
        
    }
    
    // MARK: - Keyboard hidding
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
}
