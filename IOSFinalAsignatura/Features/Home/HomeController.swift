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
import HGPlaceholders
import CoreData

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
    var quedadasName = [String]()
    var quedadasDate = [String]()
    var quedadasImage = [UIImage]()
    var quedadasPlace = [String]()
    var quedadasStreet = [String]()
    var quedadasArrayUsers = Array<Any>()
    var tabImage: UIImage? {
        return UIImage(named: "material_logo")
    }
    var userID: String?
    var userName: String = ""
    var refreshControl: UIRefreshControl!
    var haveQuedadas: Bool = false
    var myQuedadas = [Quedada]()
    var itemsQuedadas = [ViewQuedadaItem]()
    var placeholderCollectionView: CollectionView? {
        return myCollectionView as? CollectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeholderCollectionView?.placeholdersProvider = .default
        placeholderCollectionView?.placeholderDelegate = self
        placeholderCollectionView?.showLoadingPlaceholder()
        
        menuView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        getEmailFromCoreData()
        setupNameInNav()
        setUpRefreshControl()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showsSpinner()
        
        userID = Auth.auth().currentUser?.uid
        Quedadas.getQuedadas(userID: userID!, delegate: self)
        Quedadas.getUsers(delegate: self)
        
        UserDefaults.standard.set(true, forKey: "show_spinner")
    }
    
    private func setupNameInNav() {
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: 50, height: 40))
        label.font = UIFont.boldSystemFont(ofSize: 17)
        
        label.text = userName
        label.numberOfLines = 2
        label.textColor = .white
        label.sizeToFit()
        label.textAlignment = .center
        
        self.navigationItem.titleView = label
    }
    
    func getEmailFromCoreData() {
        let context = PersistenceService.context
        let fechtRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Usuarios")
        
        do {
            let result = try context.fetch(fechtRequest)
            for data in result as! [NSManagedObject] {
                userName = data.value(forKey: "email") as! String
            }
        } catch {
            print("ERROR, SOMETHING WRONG")
        }
    }
    
    func setUpRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Swipe to refresh")
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        myCollectionView.addSubview(refreshControl)
    }
    @objc func refresh() {
        refreshControl.beginRefreshing()
        
        showsSpinner()
        self.quedadas.removeAll()
        
        Quedadas.getQuedadas(userID: userID!, delegate: self)
        
        refreshControl.endRefreshing()
    }
    
    private func showsSpinner() {
        if (UserDefaults.standard.bool(forKey: "show_spinner")) {
            self.showSpinner()
        }
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
            self.myQuedadas.removeAll()
            self.itemsQuedadas.removeAll()
            self.removeSpinner()
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
        
        for (key, value) in self.quedadas {
            myQuedadas.append(Quedada(id: key, quedadaname: value[0] as! String, quedadaplace: value[3] as! String, quedadastreet: value[4] as! String, quedadadate: value[1] as! String, quedadaimage: value[2] as! UIImage))
            quedadasArrayUsers = value[5] as! Array<Any>
        }
        
        itemsQuedadas = myQuedadas.map { ViewQuedadaItem(item: $0) }
        cell.item = itemsQuedadas[indexPath.row]
        
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
        if let controller = storyboard?.instantiateViewController(withIdentifier: "QuedadaDetailController") as? QuedadaDetailController {
            
            controller.quedadaImageSelected = itemsQuedadas[indexPath.row].quedadaimage
            controller.quedadaNameSelected = itemsQuedadas[indexPath.row].quedadaname
            controller.quedadaDateSelected = itemsQuedadas[indexPath.row].quedadadate
            controller.quedadaPlaceSelected = itemsQuedadas[indexPath.row].quedadaplace
            controller.quedadaStreetSelected = itemsQuedadas[indexPath.row].quedadastreet
            controller.quedadaArrayUsersSelected = quedadasArrayUsers
            
            controller.modalTransitionStyle = .flipHorizontal
            
            present(controller, animated: true, completion: nil)
        }
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
                                            self.deleteDataFromCoreData()
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
    
    func deleteDataFromCoreData() {
        let context = PersistenceService.context
        let fechtRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Usuarios")
        
        do {
            let test = try context.fetch(fechtRequest)
            
            if (!test.isEmpty) {
                let objectToDelete = test[0] as! NSManagedObject
                context.delete(objectToDelete)
            }
            do {
                try context.save()
            }
            catch {
                print(error)
            }
        }
        catch {
            print(error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "newQuedada") {
            
            let destinationVC = segue.destination as! NewQuedadaController
            destinationVC.userID = userID
            destinationVC.users = users
        }
    }
}

extension HomeController: PlaceholderDelegate {
    func view(_ view: Any, actionButtonTappedFor placeholder: Placeholder) {
        (view as? CollectionView)?.showDefault()
    }
}
