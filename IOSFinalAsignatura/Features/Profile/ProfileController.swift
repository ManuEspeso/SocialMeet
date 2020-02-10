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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        /*let user = Auth.auth().currentUser
        if let user = user {
          
          let uid = user.uid
          let email = user.email
            
            
          print(email)
            
            
        }*/
        
        
        
        db = Firestore.firestore()


            let userID : String = (Auth.auth().currentUser?.uid)!
            print("Current user ID is" + userID)
        
        let queryRef = Database.database().reference().child("users")
        
       /* queryRef.child(userID).observeSingleEvent(of: .value, with: { (DataSnapshot) in
                print("prueba")
                print(DataSnapshot)
            
                let value = DataSnapshot.value as? NSDictionary
                let username = value?["imageProfile"] as? String ?? ""
                print(username)
            
                
            }) { (Error) in
                print("error")
            }*/
            
            
       /* queryRef.child(userID).queryOrderedByKey().observe(.value) { (DataSnapshot) in
            print("prueba")
                print(DataSnapshot)
            
                let value = DataSnapshot.value as? NSDictionary
                let username = value?["imageProfile"] as? String ?? ""
                print(username)
            
        }
            
            
        */

        
        //QV7W70zj3MVNZcFfCDp0ItWdrH33
        
        
        
       
        
        
        
        var userRef: DocumentReference!
            
            let docRef = db.collection("users").document(userID)
        
            docRef.getDocument { (document, error) in
                
                if let document = document, document.exists {
                    
                    var quedadasValue = document.get("username") as! String
                    var quedadasValue2 = document.get("email") as! String
                    var quedadasValue3 = document.get("imageProfile") as! String
                    
                    
                    
                    print(quedadasValue3)
                }
            }
        
            

        }
        
        
        
        
}

