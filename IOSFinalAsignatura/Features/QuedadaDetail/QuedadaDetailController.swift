//
//  QuedadaDetailViewController.swift
//  IOSFinalAsignatura
//
//  Created by Manu Espeso on 15/02/2020.
//  Copyright © 2020 Manuel Espeso Martin. All rights reserved.
//

import UIKit

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
    var quedadaArrayUsersSelected: Array<Any>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mTableView.delegate = self
        mTableView.dataSource = self
        mTableView.allowsMultipleSelection = true
        mTableView.allowsMultipleSelectionDuringEditing = true
        
        quedadaImage.layer.cornerRadius = quedadaImage.bounds.width/2
        quedadaImage.clipsToBounds = true
        
        setUpIBOutlets()
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? QuedadaDetailViewCell {
            let user = quedadaArrayUsersSelected![indexPath.row] as! String
            cell.userNameLabel.text = user
            
            return cell
        }
        return UITableViewCell()
    }
}
