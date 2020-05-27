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

class QuedadaDetailController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var quedadaImage: UIImageView!
    @IBOutlet weak var quedadaName: UILabel!
    @IBOutlet weak var quedadaPlace: UILabel!
    @IBOutlet weak var quedadaStreet: UILabel!
    @IBOutlet weak var quedadaDate: UILabel!
    @IBOutlet weak var mTableView: UITableView!
    
    var quedadaImageSelected: UIImage?
    var quedadaNameSelected: String?
    var quedadaPlaceSelected: String?
    var quedadaStreetSelected: String?
    var quedadaDateSelected: String?
    var quedadaArrayUsersSelected: Array<String>?
    var usersImage: [String:String] = [:]
    var userImage = [UserImage]()
    var itemsUsersImage = [ViewUserItemImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mTableView.delegate = self
        mTableView.dataSource = self
        mTableView.allowsMultipleSelection = true
        mTableView.allowsMultipleSelectionDuringEditing = true
        
        quedadaImage.layer.cornerRadius = quedadaImage.bounds.width/2
        quedadaImage.clipsToBounds = true
        
        setUpIBOutlets()
        
        for (key, value) in self.usersImage {
            userImage.append(UserImage(id: key, image: value))
        }
    }
    
    func setUpIBOutlets() {
        quedadaImage.image = quedadaImageSelected
        quedadaName.text = quedadaNameSelected
        quedadaPlace.text = quedadaPlaceSelected
        quedadaStreet.text = quedadaStreetSelected
        quedadaDate.text = quedadaDateSelected
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
