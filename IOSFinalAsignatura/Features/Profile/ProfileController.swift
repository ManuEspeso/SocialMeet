//
//  ViewControllerEX.swift
//  IOSFinalAsignatura
//
//  Created by Manu Espeso on 31/12/2019.
//  Copyright © 2019 Manuel Espeso Martin. All rights reserved.
//


import UIKit
import AMTabView
import Firebase
import FirebaseDatabase
import FirebaseAuth

class ProfileController: UIViewController {
    
    var db: Firestore!
    var userRef: DocumentReference!
    var imagePicker: UIImagePickerController!
    
    var userID: String = ""
    var userEmail: String = ""
    var userName: String = ""
    var userImage: String = ""
    
    @IBOutlet weak var imageProfileView: UIImageView!
    @IBOutlet weak var userEmailOutlet: UILabel!
    @IBOutlet weak var usernameOutlet: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        imageProfileView.layer.cornerRadius = imageProfileView.bounds.height/2
        imageProfileView.clipsToBounds = true
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        getUserDatas()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ProfileController.tapEmail))
        userEmailOutlet.isUserInteractionEnabled = true
        userEmailOutlet.addGestureRecognizer(tap)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(ProfileController.tapName))
        usernameOutlet.isUserInteractionEnabled = true
        usernameOutlet.addGestureRecognizer(tap2)
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(ProfileController.tapImage))
        imageProfileView.isUserInteractionEnabled = true
        imageProfileView.addGestureRecognizer(tap3)
    }
    
    @objc func tapEmail(sender: UITapGestureRecognizer) {
        
        let alert = UIAlertController(title: emailTextTitle.toLocalized(), message: emailTextMessage.toLocalized(), preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = self.userEmailOutlet.text
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            self.userEmailOutlet.text = textField?.text
            self.db.collection("users").document(self.userID).updateData(["email": textField?.text! as Any])
            
            if let user = Auth.auth().currentUser {
                user.updateEmail(to: (textField?.text!)!)
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func tapName(sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: nameTextTitle.toLocalized(), message: nameTextMessage.toLocalized(), preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = self.usernameOutlet.text
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            self.usernameOutlet.text = textField?.text
            self.db.collection("users").document(self.userID).updateData(["username": textField?.text! as Any])
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func tapImage(sender: UITapGestureRecognizer) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func getUserDatas() {
        let userID : String = (Auth.auth().currentUser?.uid)!
        guard let userPhoto: URL = Auth.auth().currentUser?.photoURL else {
            let docRef = db.collection("users").document(userID)
            
            docRef.getDocument { (document, error) in
                
                if let document = document, document.exists {
                    //gets fields
                    self.userID = document.get("id") as! String
                    self.userName = document.get("username") as! String
                    self.userEmail = document.get("email") as! String
                    self.userImage = document.get("imageProfile") as! String
                    
                    self.userEmailOutlet.text = self.userEmail
                    self.usernameOutlet.text = self.userName
                    //download the profileImage to show
                    let storage = Storage.storage()
                    var reference: StorageReference!
                    reference = storage.reference(forURL: self.userImage)
                    reference.downloadURL { (url, error) in
                        let data = NSData(contentsOf: url!)
                        let image = UIImage(data: data! as Data)
                        
                        self.imageProfileView.image = image
                        
                    }
                    Auth.auth().signIn(withEmail: self.userEmail, password: "123456")
                }
            }
            return
        }
        
        if (userPhoto.absoluteString.contains("googleusercontent.com")) {
            if let data = try? Data(contentsOf: userPhoto) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.imageProfileView.image = image
                    }
                }
            }
            
            let docRef = db.collection("users").document("\(userID)1")
            
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    self.userEmailOutlet.text = document.get("email") as? String
                    self.usernameOutlet.text = document.get("username") as? String
                }
            }
        }
    }
}

extension ProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imageProfileView.image = pickedImage
            
            let storageRef = Storage.storage().reference().child("users/\(userID)")
            
            if let imageData = UIImageJPEGRepresentation(imageProfileView.image!, 1) {
                storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        self.showAlert(alertText: somethingWrong.toLocalized(), alertMessage: errorMessageImage.toLocalized())
                        return
                    }
                    
                    storageRef.downloadURL{ url, error in
                        self.db.collection("users").document(self.userID).updateData(["imageProfile": url!.absoluteString])
                    }
                })
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
