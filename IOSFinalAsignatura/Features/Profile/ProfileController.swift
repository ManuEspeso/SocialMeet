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
        
        animatedBackgroundColor()
        
        imageProfileView.layer.cornerRadius = imageProfileView.bounds.height/2
        imageProfileView.clipsToBounds = true
        
         cardView.layer.cornerRadius = 20.0
           cardView.layer.shadowColor = UIColor.gray.cgColor
           cardView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
           cardView.layer.shadowRadius = 12.0
           cardView.layer.shadowOpacity = 0.7
        
        iconImageView.layer.cornerRadius = imageProfileView.bounds.height/2
        iconImageView.clipsToBounds = true
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
        
        UIView.transition(with: profileView, duration: 2, options: [.transitionCrossDissolve], animations: {
            self.profileView.firstColor = self.colorArray[self.currentColorArrayIndex].color1
            self.profileView.secondColor = self.colorArray[self.currentColorArrayIndex].color2
        }) { (success) in
            self.animatedBackgroundColor()
        }
    }

}

