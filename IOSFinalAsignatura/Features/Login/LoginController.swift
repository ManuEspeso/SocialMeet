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
    
    var db: Firestore!
    var colorArray: [(color1: UIColor, color2: UIColor)] = []
    var currentColorArrayIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginbutton.layer.cornerRadius = 8
        googleAction.layer.cornerRadius = 18
        
        GIDSignIn.sharedInstance().presentingViewController = self
        
        db = Firestore.firestore()
        
        animatedBackgroundColor()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Cuando el Core Data este bien implementado descomentar esta linea para que el autoLogin pueda funcionar
        //autoLogIn()
        
        userEmail.text = ""
        userPassword.text = ""
        
        GIDSignIn.sharedInstance()?.delegate = self
    }
    
    func animatedBackgroundColor() {
        
        colorArray.append((color1: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), color2: #colorLiteral(red: 0.5631721616, green: 0.2642064691, blue: 0.8086007237, alpha: 1)))
        colorArray.append((color1: #colorLiteral(red: 0.5631721616, green: 0.2642064691, blue: 0.8086007237, alpha: 1), color2: #colorLiteral(red: 0.3322192132, green: 0.4146331549, blue: 0.722286284, alpha: 1)))
        colorArray.append((color1: #colorLiteral(red: 0.3308110141, green: 0.4146197245, blue: 0.7213475571, alpha: 1), color2: #colorLiteral(red: 0.1417086422, green: 0.3959283233, blue: 0.5574072599, alpha: 1)))
        colorArray.append((color1: #colorLiteral(red: 0.1426705582, green: 0.3946132866, blue: 0.558653236, alpha: 1), color2: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)))
        colorArray.append((color1: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), color2: #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)))
        colorArray.append((color1: #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), color2: #colorLiteral(red: 0.5783597827, green: 0.2174208462, blue: 0.2618263066, alpha: 1)))
        colorArray.append((color1: #colorLiteral(red: 0.5791759201, green: 0.21610692, blue: 0.2619484737, alpha: 1), color2: #colorLiteral(red: 0.8088718057, green: 0.1266443729, blue: 0.09936664253, alpha: 1)))
        colorArray.append((color1: #colorLiteral(red: 0.8078431487, green: 0.1259950001, blue: 0.09925139542, alpha: 1), color2: #colorLiteral(red: 0.7112349302, green: 0.1953888395, blue: 0.2990221151, alpha: 1)))
        
        currentColorArrayIndex = currentColorArrayIndex == (colorArray.count - 1) ? 0 : currentColorArrayIndex + 1
        
        UIView.transition(with: loginView, duration: 2, options: [.transitionCrossDissolve], animations: {
            self.loginView.firstColor = self.colorArray[self.currentColorArrayIndex].color1
            self.loginView.secondColor = self.colorArray[self.currentColorArrayIndex].color2
        }) { (success) in
            self.animatedBackgroundColor()
        }
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
                    //_ = self.saveInCoreData(email: userEmail, id: user.uid)
                    self.goToHomePage()
                } else {
                    print(error!)
                }
            }
        }
    }
    
    /*func saveInCoreData(email: String, id: String) -> Bool {
     
     let personaEntity = NSEntityDescription.entity(forEntityName: "Usuarios", in: PersistenceService.context)!
     let usuario = NSManagedObject(entity: personaEntity, insertInto: PersistenceService.context)
     
     usuario.setValue(email, forKey: "email")
     usuario.setValue(id, forKey: "id")
     
     return PersistenceService.saveContext()
     }*/
    
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
            // TODO: Hay que bajarse las quedadas del usuario y añadirlas en este apartado por que si no al loguearse se eliminan el apartado quedadas de su usuario
        ]
        db.collection("users").document(userId).setData(docData) { err in
            
            if let err = err {
                print("Error writing user on database: \(err)")
            } else {
                print("User successfully write in database!")
            }
        }
    }
    
    func autoLogIn() {
        /*let context = PersistenceService.context
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
         }*/
    }
    
    func goToHomePage() {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "TabBarController") as? TabBarController {
            
            controller.modalTransitionStyle = .flipHorizontal
            controller.modalPresentationStyle = .fullScreen
            
            present(controller, animated: true, completion: nil)
        }
    }
}

