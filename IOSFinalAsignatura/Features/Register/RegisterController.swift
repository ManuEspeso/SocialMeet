//
//  RegisterController.swift
//  IOSFinalAsignatura
//
//  Created by Manu Espeso on 20/12/2019.
//  Copyright © 2019 Manuel Espeso Martin. All rights reserved.
//

import UIKit
import Firebase



class RegisterController: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpButton.layer.cornerRadius = 8
        
        db = Firestore.firestore()
        
        //ImagePicker testing de pernas
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        
        profileImageView.layer.cornerRadius = profileImageView.bounds.height/2
        profileImageView.clipsToBounds = true
        
        
        //button
        uploadProfileImage.addTarget(self, action: #selector(openImagePicker), for: .touchUpInside)
        
        
        
        
    }
    
    @objc func openImagePicker(_ sender: Any) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func createUser() {
        
        guard let userName = userName.text else {return}
        guard let userEmail = userEmail.text else {return}
        guard let userPassword = userPassword.text else {return}
        
        
        Auth.auth().createUser(withEmail: userEmail, password: userPassword) { authResult, error in
            
            if let error = error {
                print("Failed to sign user in with error: ", error.localizedDescription)
                return
            } else {
                //If the user was created succesfuly, create a instance for the user and ckeck it if an error appeard
                let user = Auth.auth().currentUser
                
                
                
                if let user = user {
                    //Esta linea comentada servira para guardar los datos del user al registrase en el core data para el auto login
                    //_ = self.saveInCoreData(email: userEmail, id: user.uid)
                    self.insertUsersOnDB(userId: user.uid, userName: userName, userEmail: userEmail)
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
    
    func insertUsersOnDB(userId: String, userName: String, userEmail: String) {
        
        guard let myImage = profileImageView.image else {return}
        
        let docData: [String: Any] = [
            "username": userName,
            "email": userEmail
        ]
        
        db.collection("users").document(userId).setData(docData) { err in
            
            if let err = err {
                print("Error writing user on database: \(err)")
            } else {
                self.goToHomePage()
            }
        }
    
    
    let filename = "earth.jpg"
        
    var imageReference: StorageReference {
        return Storage.storage().reference().child("images")
    }
    
    
    guard let imageData = UIImageJPEGRepresentation(myImage, 1) else { return }
    
    let uploadImageRef = imageReference.child(filename)
    
    let uploadTask = uploadImageRef.putData(imageData, metadata: nil) { (metadata, error) in
        print("UPLOAD TASK FINISHED")
        print(metadata ?? "NO METADATA")
        print(error ?? "NO ERROR")
    }
    
    uploadTask.observe(.progress) { (snapshot) in
    print(snapshot.progress ?? "NO MORE PROGRESS")
    }
    
    uploadTask.resume()
    
    }
    
    
    
    
    
    
    
    /*//insertar foto en db
    func uploadProfilePhoto(_ image: UIImage, completion: @escaping ((_ url: String?)->())) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("users/\(uid)")
        
        
        guard let imageData = UIImageJPEGRepresentation(image, 0.75) else {return}
        
        let metaData = StorageMetadata()
        
        metaData.contentType = "image/jpg"
        
        storageRef.putData(imageData, metadata: metaData)  { metaData, error in
            if error == nil , metaData != nil  {
                if let url  = storageRef.downloadURL(completion: { (url, error) in
                    <#code#>
                }) {
                    completion(url)
                }else {
                    completion(nil)
                }
                //success
            }else {
                //failed
                completion(nil)
            }
        }
        
    }*/

    
    func goToHomePage() {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "UINavigationController") as? UINavigationController {
            
            controller.modalTransitionStyle = .flipHorizontal
            controller.modalPresentationStyle = .fullScreen
            
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
