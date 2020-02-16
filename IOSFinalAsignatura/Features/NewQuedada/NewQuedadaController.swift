//
//  NewQuedadaController.swift
//  IOSFinalAsignatura
//
//  Created by Manu Espeso on 30/01/2020.
//  Copyright © 2020 Manuel Espeso Martin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class NewQuedadaController: UIViewController, UITableViewDataSource, UITableViewDelegate, QuedadasDelegate {
    
    @IBOutlet weak var mTableView: UITableView!
    @IBOutlet weak var quedadaName: UITextField!
    @IBOutlet weak var quedadaPlace: UITextField!
    @IBOutlet weak var quedadaStreet: UITextField!
    @IBOutlet weak var quedadaDate: UIDatePicker!
    @IBOutlet weak var quedadaImageView: UIImageView!
    @IBOutlet weak var uploadQuedadaImage: UIButton!
    @IBOutlet weak var topCustomButton: CustomButton!
    @IBAction func customButton(_ sender: CustomButton) {
        
        let quedadasName = quedadaName.text
        let quedadasPlace = quedadaPlace.text
        let quedadasStreet = quedadaStreet.text
        let myImage = quedadaImageView.image
        let quedadasDate = handler(sender: quedadaDate)
        
        if !quedadasName!.isEmpty && !quedadasPlace!.isEmpty && !quedadasStreet!.isEmpty && !quedadasDate.isEmpty && myImage != nil  {
            arrayUsersID = selectedItems.map { $0.id }
            arrayUsersName = selectedItems.map { $0.username }
            insertQuedada()
        } else {
            topCustomButton.shake()
        }
    }
    
    var userID: String?
    var db: Firestore!
    var users: [String:String] = [:]
    var usernames = [User]()
    var arrayUsersID = [String]()
    var arrayUsersName = [String]()
    var itemsUsers = [ViewUserItem]()
    var imagePicker: UIImagePickerController!
    var userName: String = ""
    
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
        
        Quedadas.getMyUserName(userID: self.userID!, delegate: self)
        
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
        let quedadasDate = handler(sender: quedadaDate)
        
        if self.arrayUsersID.count > 0  {
            let tempId = self.db.collection("quedadas").document().documentID
            
            let storageRef = Storage.storage().reference().child("quedadas/\(tempId)")
            if let imageData = UIImageJPEGRepresentation(quedadaImageView.image!, 1) {
                storageRef.putData(imageData, metadata: nil, completion:
                    { (_, error) in
                        
                        if error != nil {
                            print(error!)
                            return
                        }
                        
                        self.arrayUsersName.append(self.userName)
                        
                        storageRef.downloadURL{ url, error in
                            let docData: [String: Any] = [
                                "id": tempId,
                                "lugar": self.quedadaPlace.text!,
                                "nombre": self.quedadaName.text!,
                                "calle": self.quedadaStreet.text!,
                                "fecha": quedadasDate,
                                "usuarios": self.arrayUsersName,
                                "imageQuedada": url!.absoluteString,
                            ]
                            
                            if let error = error {
                                print(error)
                            } else {                                
                                self.db.collection("quedadas").document(tempId).setData(docData) { err in
                                    if let err = err {
                                        print("Error writing user on database: \(err)")
                                    } else {
                                        Quedadas.getArrayQuedadas(userID: self.userID!, quedadaId: tempId, delegate: self)
                                        self.getAllUsersQuedadasReference(quedadaID: tempId)
                                    }
                                }
                            }
                        }
                        
                })
            }
        } else {
            self.showAlert(alertText: "Without Members!", alertMessage: "You should add one members at leats if you want create a new meet")
        }
    }
    
    func getMyUserName(userName: String) {
        self.userName = userName
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
