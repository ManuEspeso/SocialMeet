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

class HomeController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, TabItem, QuedadasDelegate {
    
    @IBAction func menuTapped(_ sender: FloatingActionButton) {
        UIView.animate(withDuration: 0.3, animations: {
            if self.menuView.transform == .identity {
                self.menuView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            } else {
                self.menuView.transform = .identity
            }
        })
    }
    @IBAction func logoutButton(_ sender: Any) {
        signOut()
    }
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var menuView: UIViewX!
    
    var quedadas: [String: [String]] = [:]
    var quedadasName = [String]()
    var quedadasPlace = [String]()
    var tabImage: UIImage? {
        return UIImage(named: "material_logo")
    }
    let locationImages = [UIImage(named: "material_logo"), UIImage(named: "material_logo"), UIImage(named: "material_logo"),  UIImage(named: "material_logo"),  UIImage(named: "material_logo"),  UIImage(named: "material_logo")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userID = Auth.auth().currentUser?.uid
        Quedadas.getQuedadas(userID: userID!, delegate: self)
        
        menuView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
    }
    
    func getAllQuedadas(quedadas: [String : [String]]) {
        self.quedadas = quedadas
        myCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return quedadas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeViewCell
        
        for (_, value) in self.quedadas {
            quedadasName.append(value[0])
            quedadasPlace.append(value[1])
        }
        cell.locationImage.image = locationImages[indexPath.row]
        cell.locationName.text = quedadasName[indexPath.row]
        cell.locationDescription.text = quedadasPlace[indexPath.row]
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func signOut() {
        let alert = UIAlertController(title: "Sign Out",
                                      message: "Are you sure do you want to Sign Out?",
                                      preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: UIAlertAction.Style.default,
                                      handler: nil))
        alert.addAction(UIAlertAction(title: "Sign Out",
                                      style: UIAlertAction.Style.destructive,
                                      handler: { action in
                                        do {
                                            //Sign out the session in Firebase
                                            try Auth.auth().signOut()
                                            //Delete user datas from the core data
                                            //self.deleteDataFromCoreData()
                                            //Segue for go to the Login View
                                            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "LoginController") as? LoginController {
                                                
                                                controller.modalTransitionStyle = .flipHorizontal
                                                controller.modalPresentationStyle = .fullScreen
                                                
                                                self.present(controller, animated: true, completion: nil)
                                            }
                                        } catch let err {
                                            print("Failed to sign out with error", err)
                                        }
        }))
        self.present(alert,
                     animated: true,
                     completion: nil)
    }
}



