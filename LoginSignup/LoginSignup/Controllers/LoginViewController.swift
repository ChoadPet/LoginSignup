//
//  LoginViewController.swift
//  LoginSignup
//
//  Created by Vetaliy Poltavets on 3/13/18.
//  Copyright © 2018 vpoltave. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var errorLbl: UILabel!
    
    var user = User()
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        errorLbl.isHidden = true
        backgroundImage.clipsToBounds = true
        emailTextField.customTextField()
        passwordTextField.customTextField()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        errorLbl.isHidden = true
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    // MARK: - Actions
    @IBAction func loginPressed(_ sender: UIButton) {
        if !(emailTextField.text?.isEmpty)! && !(passwordTextField.text?.isEmpty)! {
            user.email = emailTextField.text!
            user.password = passwordTextField.text!
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            NetworkManager.loginMethod(forUser: user, completion: { [weak self] (success, message) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                guard let strongSelf = self else { return }
                if !success {
                    strongSelf.errorLbl.isHidden = false
                    strongSelf.errorLbl.text = message
                } else {
                    DispatchQueue.main.async {
                        strongSelf.errorLbl.isHidden = true
                        strongSelf.performSegue(withIdentifier: "fromLogin", sender: self)
                    }
                }
            })
        } else {
            errorLbl.isHidden = false
            errorLbl.text = "Email/password can't be empty!"
        }
        
    }
    
    // MARK: - Keyboard hidding
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }

}
