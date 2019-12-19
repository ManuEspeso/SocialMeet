//
//  ViewController.swift
//  IOSFinalAsignatura
//
//  Created by Manuel Espeso Martin on 11/12/19.
//  Copyright © 2019 Manuel Espeso Martin. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginController: UIViewController, GIDSignInDelegate {
    
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var loginbutton: UIButton!
    @IBAction func loginButtonPressed(_ sender: Any) {
        loginUser()
    }
    @IBOutlet weak var googleAction: GIDSignInButton!
    
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginbutton.layer.cornerRadius = 8
        googleAction.layer.cornerRadius = 18
        
        GIDSignIn.sharedInstance().presentingViewController = self
        
        db = Firestore.firestore()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //autoLogIn()
        
        userEmail.text = ""
        userPassword.text = ""
        
        GIDSignIn.sharedInstance()?.delegate = self
    }
    
    func loginUser() {
        guard let userEmail = userEmail.text else {return}
        guard let userPassword = userPassword.text else {return}
        
        Auth.auth().signIn(withEmail: userEmail, password: userPassword) { (user, error) in
            
            if let error = error {
                print("Failed to sign user in with error: ", error.localizedDescription)
                return
            } else {
                
                if let user = Auth.auth().currentUser {
                    //Aqui se llamara a una funcion en la que se guarden los datos de la variable user en el core data
                    self.goToHomePage()
                } else {
                    print(error!)
                }
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("Failed to sign in with error:", error)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (result, error) in
            
            if let error = error {
                print("Failed to sign in and retrieve data with error:", error)
                return
            }
            
            guard let uid = result?.user.uid else { return }
            guard let email = result?.user.email else { return }
            guard let username = result?.user.displayName else { return }
            
            self.insertGoogleUserOnDB(userId: uid, userName: username, userEmail: email)
            self.goToHomePage()
        }
    }
    
    func insertGoogleUserOnDB(userId: String, userName: String, userEmail: String) {
        let docData: [String: Any] = [
            "username": userName,
            "email": userEmail
        ]
        db.collection("users").document(userId).setData(docData) { err in
            
            if let err = err {
                print("Error writing user on database: \(err)")
            } else {
                print("User successfully writte in database!")
            }
        }
    }
    
    func goToHomePage() {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "UINavigationController") as? UINavigationController {
            
            controller.modalTransitionStyle = .flipHorizontal
            controller.modalPresentationStyle = .fullScreen
            
            present(controller, animated: true, completion: nil)
        }
    }
}

