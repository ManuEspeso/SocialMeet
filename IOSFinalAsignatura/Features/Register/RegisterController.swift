//
//  RegisterController.swift
//  IOSFinalAsignatura
//
//  Created by Manu Espeso on 20/12/2019.
//  Copyright © 2019 Manuel Espeso Martin. All rights reserved.
//

import UIKit

class RegisterController: UIViewController {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBAction func signUpButtonAction(_ sender: Any) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         signUpButton.layer.cornerRadius = 8
    }
}
