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
    
    var quedadas: [String: [Any]] = [:]
    var users: [String:String] = [:]
    var quedadasID = [String]()
    var quedadasName = [String]()
    var quedadasDate = [String]()
    var quedadasImage = [UIImage]()
    var tabImage: UIImage? {
        return UIImage(named: "material_logo")
    }
    var userID: String?
    var refreshControl: UIRefreshControl!
    let locationImages = [UIImage(named: "material_logo"), UIImage(named: "material_logo"), UIImage(named: "material_logo"),  UIImage(named: "material_logo")]
    let locationImages2 = ["material_logo1", "material_logo2", "material_logo3", "material_logo4"]
    let locationImages3 = ["material_logo1", "material_logo2", "material_logo3", "material_logo4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userID = Auth.auth().currentUser?.uid
        Quedadas.getQuedadas(userID: userID!, delegate: self)
        Quedadas.getUsers(delegate: self)
        
        menuView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        setUpRefreshControl()
    }
    
    func setUpRefreshControl() {
     refreshControl = UIRefreshControl()
     refreshControl.attributedTitle = NSAttributedString(string: "Arrastra para refrescar")
     refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
     myCollectionView.addSubview(refreshControl)
     }
     @objc func refresh() {
        refreshControl.beginRefreshing()
     Quedadas.getQuedadas(userID: userID!, delegate: self)
        refreshControl.endRefreshing()
     }
    
    func run(after seconds: Int, completion: @escaping () -> Void) {
        let deadline = DispatchTime.now() + .seconds(seconds)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            completion()
        }
    }
    
    func getAllQuedadas(quedadas: [String : [Any]]) {
        self.quedadas = quedadas
        run(after: 1) {
            self.myCollectionView.reloadData()
        }
    }
    
    func getAllUsers(users: [String : String]) {
        self.users = users
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return quedadas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeViewCell
        
        for (_, value) in self.quedadas {
            quedadasName.append(value[0] as! String)
            quedadasDate.append(value[1] as! String)
            quedadasImage.append(value[2] as! UIImage)
        }
        
        /*if quedadas.count == 0 {
         cell.locationImage.image = nil
         cell.locationName.text = nil
         cell.locationDescription.text = nil
         } else {*/
        cell.locationImage.image = quedadasImage[indexPath.row]
        cell.locationName.text = quedadasName[indexPath.row]
        cell.locationDescription.text = quedadasDate[indexPath.row]
        //}
        
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
                                            try Auth.auth().signOut()
                                            //self.deleteDataFromCoreData()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "newQuedada") {
            
            let destinationVC = segue.destination as! NewQuedadaController
            destinationVC.userID = userID
            destinationVC.users = users
        }
    }
}



