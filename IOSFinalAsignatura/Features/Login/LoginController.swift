//
//  ViewController.swift
//  IOSFinalAsignatura
//
//  Created by Manuel Espeso Martin on 11/12/19.
//  Copyright © 2019 Manuel Espeso Martin. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {

    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var loginbutton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginbutton.layer.cornerRadius = 8
    }
}

