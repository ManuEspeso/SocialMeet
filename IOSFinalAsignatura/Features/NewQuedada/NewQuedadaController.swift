//
//  NewQuedadaController.swift
//  IOSFinalAsignatura
//
//  Created by Manu Espeso on 30/01/2020.
//  Copyright © 2020 Manuel Espeso Martin. All rights reserved.
//

import UIKit
import Firebase

class NewQuedadaController: UIViewController, UITableViewDataSource, UITableViewDelegate, QuedadasDelegate {
    
    @IBOutlet weak var mTableView: UITableView!
    @IBOutlet weak var quedadaName: UITextField!
    @IBOutlet weak var quedadaPlace: UITextField!
    @IBOutlet weak var quedadaStreet: UITextField!
    @IBOutlet weak var quedadaDate: UIDatePicker!
    @IBOutlet weak var quedadaImageView: UIImageView!
    @IBOutlet weak var uploadQuedadaImage: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBAction func addQuedada(_ sender: Any) {
        arrayUsersID = selectedItems.map { $0.id }
        insertQuedada()
    }
    
    var userID: String?
    var db: Firestore!
    var users: [String:String] = [:]
    var usernames = [User]()
    var arrayUsersID = [String]()
    var itemsUsers = [ViewUserItem]()
    var imagePicker: UIImagePickerController!
    
    var didToggleSelection: ((_ hasSelection: Bool) -> ())? {
        didSet {
            didToggleSelection?(!selectedItems.isEmpty)
        }
    }
    var selectedItems: [ViewUserItem] {
        return itemsUsers.filter { return $0.isSelected }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mTableView.delegate = self
        mTableView.dataSource = self
        mTableView.allowsMultipleSelection = true
        mTableView.allowsMultipleSelectionDuringEditing = true
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        quedadaImageView.layer.cornerRadius = quedadaImageView.bounds.width/2
        quedadaImageView.clipsToBounds = true
        
        for (key, value) in self.users {
            if key != userID {
                usernames.append(User(id: key, username: value))
            }
        }
        
        db = Firestore.firestore()
        
        uploadQuedadaImage.addTarget(self, action: #selector(openImagePicker), for: .touchUpInside)
    }
    
    @objc func openImagePicker(_ sender: Any) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func handler(sender: UIDatePicker) -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = DateFormatter.Style.long
        timeFormatter.locale = Locale(identifier: "es_ES")
        timeFormatter.dateFormat = "EEEE, yyy-MM-dd, HH:mm" /*"yyy-MM-dd'T'HH:mm"*/
        let strDate = timeFormatter.string(from: quedadaDate.date)
        
        return strDate
    }
    
    func insertQuedada() {
        guard let quedadaName = quedadaName.text else {return}
        guard let quedadaPlace = quedadaPlace.text else {return}
        guard let quedadaStreet = quedadaStreet.text else {return}
        let quedadasDate = handler(sender: quedadaDate)
        
        
        //let quedadaId = UUID().uuidString
        let tempId = self.db.collection("quedadas").document().documentID
        
        let storageRef = Storage.storage().reference().child("quedadas/\(tempId)")
        guard let myImage = quedadaImageView.image else {return}
        
        if let imageData = UIImageJPEGRepresentation(myImage, 1) {
            storageRef.putData(imageData, metadata: nil, completion:
                { (_, error) in
                    
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    storageRef.downloadURL{ url, error in
                        let docData: [String: Any] = [
                            "id": tempId,
                            "lugar": quedadaPlace,
                            "nombre": quedadaName,
                            "calle": quedadaStreet,
                            "fecha": quedadasDate,
                            "imageQuedada": url!.absoluteString,
                        ]
                        
                        if let error = error {
                            print(error)
                        } else {
                            if !quedadaName.isEmpty && !quedadaPlace.isEmpty && !quedadaStreet.isEmpty && !quedadasDate.isEmpty && self.arrayUsersID.count > 0  {
                                

                                
                                self.db.collection("quedadas").document(tempId).setData(docData) { err in
                                    if let err = err {
                                        print("Error writing user on database: \(err)")
                                    } else {
                                        Quedadas.getArrayQuedadas(userID: self.userID!, quedadaId: tempId, delegate: self)
                                        self.getAllUsersQuedadasReference(quedadaID: tempId)
                                    }
                                }
                                
                            } else {
                                self.showAlert(alertText: "Campos Vacios", alertMessage: "Rellene todos los campos y seleccione los usuarios para poder crear la quedada")
                            }
                        }
                    }
            })
        }
    }
    
    func getMyQuedadasReference(qudadasReference: Array<Any>) {
        db.collection("users").document(userID!).updateData(["quedadas": qudadasReference])
    }
    
    func getAllUsersQuedadasReference(quedadaID: String) {
        for i in 0...(arrayUsersID.count - 1) {
            var userRef: DocumentReference!
            
            let docRef = db.collection("users").document(arrayUsersID[i])
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    
                    var quedadasValue = document.get("quedadas") as! Array<Any>
                    
                    userRef = Firestore.firestore().document("quedadas/\(quedadaID)")
                    quedadasValue.append(userRef!)
                    self.db.collection("users").document(self.arrayUsersID[i]).updateData(["quedadas": quedadasValue])
                }
            }
        }
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        itemsUsers = usernames.map { ViewUserItem(item: $0) }
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NewQuedadaCell", for: indexPath) as? NewQuedadaViewCell {
            cell.item = itemsUsers[indexPath.row]
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemsUsers[indexPath.row].isSelected = true
        
        didToggleSelection?(!selectedItems.isEmpty)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        itemsUsers[indexPath.row].isSelected = false
        
        didToggleSelection?(!selectedItems.isEmpty)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath
    }
}

extension NewQuedadaController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.quedadaImageView.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
