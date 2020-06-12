//
//  QuedadaDetailViewController.swift
//  IOSFinalAsignatura
//
//  Created by Manu Espeso on 15/02/2020.
//  Copyright © 2020 Manuel Espeso Martin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class QuedadaDetailController: UIViewController, UITableViewDataSource, UITableViewDelegate, QuedadasDelegate {
    
    @IBOutlet weak var quedadaImage: UIImageView!
    @IBOutlet weak var quedadaName: UILabel!
    @IBOutlet weak var quedadaPlace: UILabel!
    @IBOutlet weak var quedadaStreet: UILabel!
    @IBOutlet weak var quedadaDate: UILabel!
    @IBOutlet weak var mTableView: UITableView!
    @IBAction func deleteQuedadaButtonTapped(_ sender: Any) {
        Quedadas.dropQuedada(Auth.auth().currentUser!.uid, quedadaIDSelected!, delegate: self)
    }
    
    var db: Firestore!
    var imagePicker: UIImagePickerController!
    var quedadaIDSelected: String?
    var quedadaImageSelected: UIImage?
    var quedadaNameSelected: String?
    var quedadaPlaceSelected: String?
    var quedadaStreetSelected: String?
    var quedadaDateSelected: String?
    var quedadaArrayUsersSelected: Array<String>?
    var usersImage: [String:String] = [:]
    var userImage = [UserImage]()
    var itemsUsersImage = [ViewUserItemImage]()
    var datePicker:UIDatePicker = UIDatePicker()
    let toolBar = UIToolbar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        mTableView.delegate = self
        mTableView.dataSource = self
        mTableView.allowsSelection = false
        
        quedadaImage.layer.cornerRadius = quedadaImage.bounds.width/2
        quedadaImage.clipsToBounds = true
        
        setUpIBOutlets()
        
        for (key, value) in self.usersImage {
            userImage.append(UserImage(id: key, image: value))
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapName))
        quedadaName.isUserInteractionEnabled = true
        quedadaName.addGestureRecognizer(tap)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(tapPlace))
        quedadaPlace.isUserInteractionEnabled = true
        quedadaPlace.addGestureRecognizer(tap2)
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(tapStreet))
        quedadaStreet.isUserInteractionEnabled = true
        quedadaStreet.addGestureRecognizer(tap3)
        
        let tap5 = UITapGestureRecognizer(target: self, action: #selector(tapDate))
        quedadaDate.isUserInteractionEnabled = true
        quedadaDate.addGestureRecognizer(tap5)
    }
    
    func setUpIBOutlets() {
        quedadaImage.image = quedadaImageSelected
        quedadaName.text = quedadaNameSelected
        quedadaPlace.text = quedadaPlaceSelected
        quedadaStreet.text = quedadaStreetSelected
        quedadaDate.text = quedadaDateSelected
    }
    
    func quedadaDeleted() {
        print("navegar a la pantalla de home")
    }
    
    @objc func tapName(sender: UITapGestureRecognizer) {
        
        let alert = UIAlertController(title: nameTextTitle.toLocalized(), message: nameTextMessage.toLocalized(), preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = self.quedadaName.text
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            self.quedadaName.text = textField?.text
            self.db.collection("quedadas").document(self.quedadaIDSelected!).updateData(["nombre": textField?.text! as Any])
            
            if let user = Auth.auth().currentUser {
                user.updateEmail(to: (textField?.text!)!)
            }
        }))
        
        alert.addAction(UIAlertAction(title: cancel.toLocalized(), style: UIAlertAction.Style.destructive, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func tapPlace(sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: placeTextTitle.toLocalized(), message: placeTextMessage.toLocalized(), preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = self.quedadaPlace.text
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            self.quedadaPlace.text = textField?.text
            self.db.collection("quedadas").document(self.quedadaIDSelected!).updateData(["lugar": textField?.text! as Any])
        }))
        
        alert.addAction(UIAlertAction(title: cancel.toLocalized(), style: UIAlertAction.Style.destructive, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func tapStreet(sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: streetTextTitle.toLocalized(), message: streetTextMessage.toLocalized(), preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = self.quedadaStreet.text
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            self.quedadaStreet.text = textField?.text
            self.db.collection("quedadas").document(self.quedadaIDSelected!).updateData(["calle": textField?.text! as Any])
        }))
        
        alert.addAction(UIAlertAction(title: cancel.toLocalized(), style: UIAlertAction.Style.destructive, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func tapDate(sender: UITapGestureRecognizer) {
        let datePicker = UIDatePicker()
        
        let alert = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        alert.view.addSubview(datePicker)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { (action) in
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.long
            dateFormatter.locale = Locale(identifier: "es_ES")
            dateFormatter.dateFormat = "dd/MM/yyyy, HH:mm"
            let dateString = dateFormatter.string(from: datePicker.date)
            
            self.quedadaDate.text = dateString
            self.db.collection("quedadas").document(self.quedadaIDSelected!).updateData(["fecha": dateString])
        })
        
        alert.addAction(UIAlertAction(title: cancel.toLocalized(), style: UIAlertAction.Style.destructive, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func tapImage(sender: UITapGestureRecognizer) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quedadaArrayUsersSelected!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        itemsUsersImage = userImage.map { ViewUserItemImage(item: $0) }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? QuedadaDetailViewCell {
            
            cell.userNameLabel.text = quedadaArrayUsersSelected![indexPath.row]
            
            if (itemsUsersImage[indexPath.row].image.contains("googleusercontent.com")) {
                let fileUrl = URL(string: itemsUsersImage[indexPath.row].image)
                
                if let data = try? Data(contentsOf: fileUrl!) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            cell.userNameImage.image = image
                        }
                    }
                }
            } else {
                let storage = Storage.storage()
                var reference: StorageReference!
                reference = storage.reference(forURL: itemsUsersImage[indexPath.row].image)
                reference.downloadURL { (url, error) in
                    let data = NSData(contentsOf: url!)
                    let image = UIImage(data: data! as Data)
                    
                    cell.userNameImage.image = image
                }
            }
            return cell
        }
        return UITableViewCell()
    }
}

extension QuedadaDetailController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.quedadaImage.image = pickedImage
            
            let storageRef = Storage.storage().reference().child("quedadas/\(self.quedadaIDSelected!)")
            
            if let imageData = UIImageJPEGRepresentation(quedadaImage.image!, 1) {
                storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        self.showAlert(alertText: somethingWrong.toLocalized(), alertMessage: errorMessageImage.toLocalized())
                        return
                    }
                    storageRef.downloadURL { url, error in
                        self.db.collection("users").document(self.quedadaIDSelected!).updateData(["imageQuedada": url!.absoluteString])
                    }
                })
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
