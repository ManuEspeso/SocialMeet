//
//  Quedada.swift
//  IOSFinalAsignatura
//
//  Created by Manu Espeso on 22/01/2020.
//  Copyright © 2020 Manuel Espeso Martin. All rights reserved.
//

import UIKit
import Firebase

class Quedadas: NSObject {
    
    static func getQuedadas(userID: String, delegate: QuedadasDelegate) {
        var quedadas: [String:[String]] = [:]
        
        let docRef = Firestore.firestore().collection("users").document(userID)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let quedadasValue = document.get("quedadas") as! NSArray
                
                let quedadasIndex = quedadasValue.count
                for i in 0...(quedadasIndex - 1) {
                    let quedadaReference = quedadasValue[i] as! DocumentReference
                    quedadaReference.getDocument { (documentSnapshot, error) in
                        
                        if let documentSnapshot = documentSnapshot, documentSnapshot.exists {
                            let dataDescription = documentSnapshot.data()
                            
                            guard let dataQuedadas = dataDescription else {return}
                            quedadas[dataQuedadas["id"] as! String] = [dataQuedadas["nombre"] as! String, dataQuedadas["lugar"] as! String]
                            delegate.getAllQuedadas!(quedadas: quedadas)
                        } else{
                            print("Document does not exist")
                        }
                    }
                }
            }
        }
    }
    
    static func getArrayQuedadas(userID: String, quedadaId: String, delegate: QuedadasDelegate) {
        var userRef: DocumentReference!
        
        let docRef = Firestore.firestore().collection("users").document(userID)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                
                var quedadasValue = document.get("quedadas") as! Array<Any>
                
                userRef = Firestore.firestore().document("quedadas/\(quedadaId)")
                quedadasValue.append(userRef!)
                
                delegate.getQuedadasReference!(qudadasReference: quedadasValue)
            }
        }
    }
    
    static func getUsers(delegate: QuedadasDelegate) {
        var users: [String:String] = [:]
        
        let docRef = Firestore.firestore().collection("users")
        docRef.getDocuments { (querysnapchot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for documents in querysnapchot!.documents {
                    docRef.document(documents.documentID).getDocument { (document, error) in
                        
                        guard let username = document?.get("username") else {return}
                        users[documents.documentID] = username as? String
                        delegate.getAllUsers?(users: users)
                    }
                }
            }
        }
    }
    static func getArrayQuedadasAllUsers(usersID: [String], quedadaId: String, delegate: QuedadasDelegate) {
        
    }
    
    /*static func getUsersID(usernameAdd: String, delegate: QuedadasDelegate) {
        let docRef = Firestore.firestore().collection("users")
        docRef.getDocuments { (querysnapchot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for documents in querysnapchot!.documents {
                    //print("\(documents.documentID) => \(documents.data())")
                    docRef.document(documents.documentID).getDocument { (document, error) in
                        
                        let username = document?.get("username") as! String
                        print("Username nuevo \(usernameAdd)")
                        print("Username de la bd \(username)")
                        if username == usernameAdd {
                            print("Si Señor")
                            print(documents.documentID)
                            //getArrayQuedadas(userID: documents.documentID, uuid: "aaaaaaaaaaaaaaaaa", delegate: QuedadasDelegate)
                        } else {
                            print("me da que no")
                        }
                        //print(username!)
                    }
                }
            }
        }
    }*/
}

@objc protocol QuedadasDelegate {
    @objc optional func getAllQuedadas(quedadas: [String:[String]])
    @objc optional func getQuedadasReference(qudadasReference: Array<Any>)
    @objc optional func getAllUsers(users: [String:String])
}

