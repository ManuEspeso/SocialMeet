//
//  RegisterController.swift
//  IOSFinalAsignatura
//
//  Created by Manu Espeso on 20/12/2019.
//  Copyright © 2019 Manuel Espeso Martin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import CoreData

class RegisterController: UIViewController {
    
    @IBOutlet var registerView: UIViewX!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBAction func signUpButtonAction(_ sender: Any) {
        createUser()
    }
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var uploadProfileImage: UIButton!
    
    var imagePicker: UIImagePickerController!
    var db: Firestore!
    var colorArray: [(color1: UIColor, color2: UIColor)] = []
    var currentColorArrayIndex = -1
    var emptyArray = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpButton.layer.cornerRadius = 8
        
        db = Firestore.firestore()
        
        //ImagePicker testing de pernas
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        profileImageView.layer.cornerRadius = profileImageView.bounds.width/2
        profileImageView.clipsToBounds = true
        
        animatedBackgroundColor()
        uploadProfileImage.addTarget(self, action: #selector(openImagePicker), for: .touchUpInside)
    }
    
    @objc func openImagePicker(_ sender: Any) {
        self.present(imagePicker, animated: true, completion: nil)
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
        
        UIView.transition(with: registerView, duration: 2, options: [.transitionCrossDissolve], animations: {
            self.registerView.firstColor = self.colorArray[self.currentColorArrayIndex].color1
            self.registerView.secondColor = self.colorArray[self.currentColorArrayIndex].color2
        }) { (success) in
            self.animatedBackgroundColor()
        }
    }
    
    func createUser() {
        
        guard let userName = userName.text else {return}
        guard let userEmail = userEmail.text else {return}
        guard let userPassword = userPassword.text else {return}
        
        self.showSpinner()
        
        Auth.auth().createUser(withEmail: userEmail, password: userPassword) { authResult, error in
            
            if let error = error {
                self.removeSpinner()
                self.showAlert(alertText: "Something Wrong", alertMessage: error.localizedDescription)
                return
            } else {
                let user = Auth.auth().currentUser
                
                if let user = user {
                    _ = self.saveInCoreData(email: userEmail, id: user.uid)
                    self.imageStorageFirebase(userId: user.uid, userName: userName, userEmail: userEmail)
                } else {
                    self.removeSpinner()
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
    
    func imageStorageFirebase(userId: String, userName: String, userEmail: String) {
        let storageRef = Storage.storage().reference().child("users/\(userId)")
        
        guard let myImage = profileImageView.image else {return}
        if let imageData = UIImageJPEGRepresentation(myImage, 1) {
            
            storageRef.putData(imageData, metadata: nil, completion:
                { (metadata, error) in
                    
                    if error != nil {
                        self.removeSpinner()
                        self.showAlert(alertText: "Something Wrong", alertMessage: error! as! String)
                        return
                    }
                    
                    storageRef.downloadURL{ url, error in
                        let docData: [String: Any] = [
                            "username": userName,
                            "email": userEmail,
                            "imageProfile": url!.absoluteString,
                            "quedadas": self.emptyArray
                        ]
                        
                        if let error = error {
                            self.removeSpinner()
                            self.showAlert(alertText: "Something Wrong", alertMessage: error as! String)
                        } else {
                            self.insertUsersOnDB(userId: userId, docData: docData)
                        }
                    }
            })
        }
    }
    
    func insertUsersOnDB(userId: String, docData: [String: Any]) {
        
        db.collection("users").document(userId).setData(docData) { err in
            
            if let err = err {
                print("Error writing user on database: \(err)")
            } else {
                self.goToHomePage()
            }
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

extension RegisterController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.profileImageView.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
