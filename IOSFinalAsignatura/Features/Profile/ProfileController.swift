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

class ProfileController: UIViewController, TabItem {
   
    
    var db: Firestore!
    var arrayUsersID = [String]()
    var userRef: DocumentReference!
    var tabImage: UIImage? {
        return UIImage(named: "ic_person_outline_white_2x")
    }
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
        
        
        //Gets current user ID
        let userID : String = (Auth.auth().currentUser?.uid)!
        
        let docRef = db.collection("users").document(userID)
        
        docRef.getDocument { (document, error) in
                
        if let document = document, document.exists {
                    
            self.userName = document.get("username") as! String
            self.userEmail = document.get("email") as! String
            self.userImage = document.get("imageProfile") as! String
            
            self.userEmailOutlet.text = self.userEmail
            self.usernameOutlet.text = self.userName
            
            
            
            
            let storage = Storage.storage()
            var reference: StorageReference!
            reference = storage.reference(forURL: self.userImage)
            reference.downloadURL { (url, error) in
                let data = NSData(contentsOf: url!)
                let image = UIImage(data: data! as Data)
                
                self.imageProfileView.image = image

            }
            
            
            
            
            
                }
        }
        
    }
}

