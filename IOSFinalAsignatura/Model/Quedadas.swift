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
                            delegate.getAllQuedadas(quedadas: quedadas)
                        } else{
                            print("Document does not exist")
                        }
                    }
                }
            }
        }
    }
}

protocol QuedadasDelegate {
    func getAllQuedadas(quedadas: [String:[String]])
}

