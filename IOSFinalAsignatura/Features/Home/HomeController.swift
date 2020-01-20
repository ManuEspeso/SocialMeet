//
//  HomeController.swift
//  IOSFinalAsignatura
//
//  Created by Manu Espeso on 25/12/2019.
//  Copyright © 2019 Manuel Espeso Martin. All rights reserved.
//

import UIKit
import AMTabView
import Firebase
import FirebaseDatabase

class HomeController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, TabItem {
    
    // TODO: Tengo que guardar la nueva quedada que cree en un hashmap o array o similar para posteriormente en users añadirselo al campo "quedadas" todas las referencias almacenadas en el hasmap con las quedadas en las que el usuario participa. Tambien tendre que hacer esto pero al reves para en el campo "usuarios" de quedadas insertar un hashmap o similar con todos los usuarios participes de la quedada.
    
    var quedadas: [String: String] = [:]
    var ref: DatabaseReference!
    var db: Firestore!
    
    var tabImage: UIImage? {
        return UIImage(named: "material_logo")
    }    
    
    let locationNames = ["Hawaii Resort", "Mountain Expedition", "Scuba Diving"]
    
    let locationImages = [UIImage(named: "material_logo"), UIImage(named: "material_logo"), UIImage(named: "material_logo")]
    
    let locationDescription = ["Beautiful resort off the coast of Hawaii", "Exhilarating mountainous expedition through Yosemite National Park", "Awesome Scuba Diving adventure in the Gulf of Mexico"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        db = Firestore.firestore()
        
        saveInHashMap()
    }
    
    
    
    func saveInHashMap() {
        
        //quedadas = ["Hello": ["1.1", "1.2"], "World": ["2.1", "2.2"]]
        
        let userID = Auth.auth().currentUser?.uid
        
        db.collection("users").whereField("id", isEqualTo: userID!)
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
                                    let dataDescription = documentSnapshot.data().map(String.init(describing:)) ?? "nil"
                                    print("Document data: \(dataDescription)")
                                    self.quedadas = [quedadaReference.documentID: dataDescription/*.replacingOccurrences(of: "\'", with: "", options: NSString.CompareOptions.literal, range: nil)*/]
                                    print("inserccion: \(self.quedadas)")
                                } else {
                                    print("Document does not exist")
                                }
                            }
                        }
                        /*document.reference.getDocument { (DocumentSnapshot, Error) in
                         print(DocumentSnapshot!)
                         }*/
                        
                        /*for quedadaID in quedadasValue {
                         self.db.collection("quedadas").whereField("id", isEqualTo: quedadaID).getDocuments { (querySnapshot, error) in
                         if let err = err {
                         print("Error getting documents: \(err)")
                         } else {
                         for documentQuedada in querySnapshot!.documents {
                         let idQuedada = documentQuedada.data().index(forKey: "id")
                         let idQuedadaValue = documentQuedada.data()[idQuedada!].value as! String
                         
                         let nombreQuedada = documentQuedada.data().index(forKey: "nombre")
                         let nombreQuedadaValue = documentQuedada.data()[nombreQuedada!].value as! String
                         
                         let lugarQuedada = documentQuedada.data().index(forKey: "lugar")
                         let lugarQuedadaValue = documentQuedada.data()[lugarQuedada!].value as! String
                         
                         print(idQuedadaValue + nombreQuedadaValue + lugarQuedadaValue)
                         
                         self.quedadas = [idQuedadaValue: [nombreQuedadaValue, lugarQuedadaValue]]
                         print(self.quedadas)
                         }
                         }
                         }
                         }*/
                    }
                }
        }
        print("fin de todo mas diccionario aqui: \(quedadas)")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locationNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeViewCell
        
        cell.locationImage.image = locationImages[indexPath.row]
        cell.locationName.text = locationNames[indexPath.row]
        cell.locationDescription.text = locationDescription[indexPath.row]
        
        //This creates the shadows and modifies the cards a little bit
        cell.contentView.layer.cornerRadius = 4.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        return cell
    }
}



