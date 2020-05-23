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
import FirebaseFirestore
import CoreData

class LoginController: UIViewController, GIDSignInDelegate {
    
    @IBOutlet weak var loginView: UIViewX!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var loginbutton: UIButton!
    @IBAction func loginButtonPressed(_ sender: Any) {
        loginUser()
    }
    @IBOutlet weak var googleAction: GIDSignInButton!
    @IBOutlet weak var imageLogo: UIImageView!
    
    var db: Firestore!
    var colorArray: [(color1: UIColor, color2: UIColor)] = []
    var currentColorArrayIndex = -1
    var email: String = ""
    var id: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginbutton.layer.cornerRadius = 8
        googleAction.layer.cornerRadius = 18
        imageLogo.layer.cornerRadius = imageLogo.bounds.width/2
        imageLogo.clipsToBounds = true
        
        GIDSignIn.sharedInstance().presentingViewController = self
        
        db = Firestore.firestore()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        autoLogIn()
        
        userEmail.text = ""
        userPassword.text = ""
        
        GIDSignIn.sharedInstance()?.delegate = self
    }

    func loginUser() {
        guard let userEmail = userEmail.text else {return}
        guard let userPassword = userPassword.text else {return}
        
        self.showSpinner()
        
        Auth.auth().signIn(withEmail: userEmail, password: userPassword) { (user, error) in
            
            if let error = error {
                self.removeSpinner()
                self.showAlert(alertText: "Something Wrong", alertMessage: error.localizedDescription)
                return
            } else {
                
                if let user = Auth.auth().currentUser {
                    _ = self.saveInCoreData(email: userEmail, id: user.uid)
                    self.goToHomePage()
                } else {
                    print(error!)
                }
            }
        }
    }
    
    func saveInCoreData(email: String, id: String) -> Bool {
        
        let personaEntity = NSEntityDescription.entity(forEntityName: "Usuarios", in: PersistenceService.context)!
        let usuario = NSManagedObject(entity: personaEntity, insertInto: PersistenceService.context)
        
        usuario.setValue(email, forKey: "email")
        usuario.setValue(id, forKey: "id")
        
        return PersistenceService.saveContext()
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
        db.collection("users").document(userId).updateData(["username": userName])
        db.collection("users").document(userId).updateData(["email": userEmail])
        db.collection("users").document(userId).updateData(["id": userId])
    }
    
    func autoLogIn() {
        let context = PersistenceService.context
        let fechtRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Usuarios")
        
        do {
            let result = try context.fetch(fechtRequest)
            
            for data in result as! [NSManagedObject] {
                email = data.value(forKey: "email") as! String
                id = data.value(forKey: "id") as! String
            }
            if(!email.isEmpty && !id.isEmpty) {
                goToHomePage()
            }
        } catch {
            print("ERROR, SOMETHING WRONG")
        }
    }
    
    func goToHomePage() {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "TabBarController") as? TabBarController {
            
            controller.modalTransitionStyle = .flipHorizontal
            controller.modalPresentationStyle = .fullScreen
            
            self.removeSpinner()
            
            present(controller, animated: true, completion: nil)
        }
    }
}

