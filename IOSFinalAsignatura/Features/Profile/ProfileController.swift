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
    
    var userEmail: String = ""
    var userName: String = ""
    var userImage: String = ""
    
    var currentColorArrayIndex = -1
    var colorArray: [(color1: UIColor, color2: UIColor)] = []
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var profileView: UIViewX!
    @IBOutlet weak var imageProfileView: UIImageView!
    @IBOutlet weak var userEmailOutlet: UILabel!
    @IBOutlet weak var usernameOutlet: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        imageProfileView.layer.cornerRadius = imageProfileView.bounds.height/2
        imageProfileView.clipsToBounds = true
        iconImageView.layer.cornerRadius = imageProfileView.bounds.height/2
        iconImageView.clipsToBounds = true
        
        setUpCardView()
        getUserDatas()
    }
    
    func setUpCardView() {
        cardView.layer.cornerRadius = 20.0
        cardView.layer.shadowColor = UIColor.gray.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cardView.layer.shadowRadius = 12.0
        cardView.layer.shadowOpacity = 0.7
    }
    
    func getUserDatas() {
        let userID : String = (Auth.auth().currentUser?.uid)!
        guard let userPhoto: URL = Auth.auth().currentUser?.photoURL else {
            let docRef = db.collection("users").document(userID)
            
            docRef.getDocument { (document, error) in
                
                if let document = document, document.exists {
                    //gets fields
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
