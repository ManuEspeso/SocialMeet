//
//  Quedada.swift
//  IOSFinalAsignatura
//
//  Created by Manu Espeso on 22/01/2020.
//  Copyright © 2020 Manuel Espeso Martin. All rights reserved.
//

import UIKit
import Firebase

class Quedadas {
    
    static func getQuedadas(userID: String) -> [String:[String]] {
        var quedadas: [String:[String]] = [:]
        
        Firestore.firestore().collection("users").whereField("id", isEqualTo: userID)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let quedadasFirebase = document.data().index(forKey: "quedadas")
                        let quedadasValue = document.data()[quedadasFirebase!].value as! NSArray
                        
                        let quedadasIndex = quedadasValue.count
                        for i in 0...(quedadasIndex - 1) {
                            let quedadaReference = quedadasValue[i] as! DocumentReference
                            quedadaReference.getDocument { (documentSnapshot, error) in
                                
                                if let documentSnapshot = documentSnapshot, documentSnapshot.exists {
                                    let dataDescription = documentSnapshot.data()
                                    
                                    guard let dataQuedadas = dataDescription else {return}
                                    quedadas[dataQuedadas["id"] as! String] = [dataQuedadas["nombre"] as! String, dataQuedadas["lugar"] as! String]
                                } else{
                                    print("Document does not exist")
                                }
                                print("--------------------------------")
                                print(quedadas)
                                print("--------------------------------")
                                
                            }
                        }
                    }
                }
        }
        sleep(3)
        return quedadas
    }
}
