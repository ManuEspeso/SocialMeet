//
//  Quedada.swift
//  IOSFinalAsignatura
//
//  Created by Manu Espeso on 22/01/2020.
//  Copyright © 2020 Manuel Espeso Martin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class Quedadas: NSObject {
    
    static func getQuedadas(userID: String, delegate: QuedadasDelegate) {
        var quedadas: [String:[Any]] = [:]
        
        DispatchQueue.global(qos: .background).async {
            
            let docRef = Firestore.firestore().collection("users").document(userID)
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let quedadasValue = document.get("quedadas") as! NSArray
                    
                    let quedadasIndex = quedadasValue.count
                    
                    if quedadasIndex != 0 {
                        for i in 0...(quedadasIndex - 1) {
                            let quedadaReference = quedadasValue[i] as! DocumentReference
                            quedadaReference.getDocument { (documentSnapshot, error) in
                                
                                if let documentSnapshot = documentSnapshot, documentSnapshot.exists {
                                    let dataDescription = documentSnapshot.data()
                                    
                                    guard let dataQuedadas = dataDescription else {return}
                                    
                                    let quedadaImage = dataQuedadas["imageQuedada"] as! String
                                    
                                    let storage = Storage.storage()
                                    var reference: StorageReference!
                                    reference = storage.reference(forURL: quedadaImage)
                                    reference.downloadURL { (url, error) in
                                        let data = NSData(contentsOf: url!)
                                        let image = UIImage(data: data! as Data)
                                        
                                        quedadas[dataQuedadas["id"] as! String] = [dataQuedadas["nombre"] as! String, dataQuedadas["fecha"] as! String, image!, dataQuedadas["lugar"] as! String, dataQuedadas["calle"] as! String, dataQuedadas["usuarios"] as! Array<Any>]
                                        DispatchQueue.main.async {
                                            delegate.getAllQuedadas!(quedadas: quedadas)
                                        }
                                    }
                                } else{
                                    print("Document does not exist")
                                }
                            }
                        }
                    } else {
                        //NO EXISTEN LAS QUEDADAS
                        DispatchQueue.main.async {
                            delegate.getAllQuedadas?(quedadas: quedadas)
                        }
                    }
                }
            }
        }
    }
    
    static func getArrayQuedadas(userID: String, quedadaId: String, delegate: QuedadasDelegate) {
        var userRef: DocumentReference!
        
        DispatchQueue.global(qos: .background).async {
            let docRef = Firestore.firestore().collection("users").document(userID)
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    
                    var quedadasValue = document.get("quedadas") as! Array<Any>
                    
                    userRef = Firestore.firestore().document("quedadas/\(quedadaId)")
                    quedadasValue.append(userRef!)
                    
                    DispatchQueue.main.async {
                        delegate.getMyQuedadasReference!(qudadasReference: quedadasValue)
                    }
                }
            }
        }
    }
    
    static func getMyUserName(userID: String, delegate: QuedadasDelegate) {
        var userName: String = ""
        DispatchQueue.global(qos: .background).async {
            let docRef = Firestore.firestore().collection("users").document(userID)
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    
                    userName = document.get("username") as! String
                    
                    DispatchQueue.main.async {
                        delegate.getMyUserName?(userName: userName)
                    }
                }
            }
        }
    }
    
    static func getUsers(delegate: QuedadasDelegate) {
        var usersName: [String:String] = [:]
        var usersImage: [String:String] = [:]
        
        DispatchQueue.global(qos: .background).async {
            
            let docRef = Firestore.firestore().collection("users")
            docRef.getDocuments { (querysnapchot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    for documents in querysnapchot!.documents {
                        docRef.document(documents.documentID).getDocument { (document, error) in
                            
                            guard let username = document?.get("username") else { return }
                            guard let userImage = document?.get("imageProfile") else { return }
                            
                            usersName[documents.documentID] = username as? String
                            usersImage[documents.documentID] = userImage as? String
                            
                            DispatchQueue.main.async {
                                delegate.getAllUsers?(usersName, usersImage)
                            }
                        }
                    }
                }
            }
        }
    }
}

@objc protocol QuedadasDelegate {
    @objc optional func getAllQuedadas(quedadas: [String: [Any]])
    @objc optional func getMyQuedadasReference(qudadasReference: Array<Any>)
    @objc optional func getAllUsers(_ usersName: [String: String], _ usersImage: [String: String])
    @objc optional func getMyUserName(userName: String)
}

