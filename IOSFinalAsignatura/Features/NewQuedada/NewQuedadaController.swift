//
//  NewQuedadaController.swift
//  IOSFinalAsignatura
//
//  Created by Manu Espeso on 30/01/2020.
//  Copyright © 2020 Manuel Espeso Martin. All rights reserved.
//

import UIKit
import Firebase

class NewQuedadaController: UIViewController, QuedadasDelegate {
    
    @IBOutlet weak var quedadaName: UITextField!
    @IBOutlet weak var quedadaPlace: UITextField!
    @IBAction func addQuedada(_ sender: Any) {
        insertQuedada()
    }
    
    var userID: String?
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
    }
    
    func insertQuedada() {
        
        guard let quedadaName = quedadaName.text else {return}
        guard let quedadaPlace = quedadaPlace.text else {return}
        
        let uuid = UUID().uuidString
        let docData: [String: Any] = [
            "id": uuid,
            "lugar": quedadaPlace,
            "nombre": quedadaName
        ]
        
        db.collection("quedadas").document(uuid).setData(docData) { err in
            if let err = err {
                print("Error writing user on database: \(err)")
            } else {
                Quedadas.getArrayQuedadas(userID: self.userID!, uuid: uuid, delegate: self)
            }
        }
    }
    
    func getQuedadasReference(qudadasReference: Array<Any>) {
        db.collection("users").document(userID!).updateData(["quedadas": qudadasReference])
    }
}
