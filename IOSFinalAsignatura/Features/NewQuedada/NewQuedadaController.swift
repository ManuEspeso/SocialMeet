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
    @IBOutlet weak var addButton: UIButton!
    @IBAction func addQuedada(_ sender: Any) {
        //insertQuedada()
        arrayUsersID = selectedItems.map { $0.id }
        
        //print(arrayUsersID)
        //print(selectedItems.map { $0.title })
    }
    
    var userID: String?
    var db: Firestore!
    var users: [String:String] = [:]
    var usernames = [User]()
    var arrayUsersID = [String]()
    var itemsUsers = [ViewUserItem]()
    
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
        
        for (key, value) in self.users {
            usernames.append(User(id: key, username: value))
        }
        
        db = Firestore.firestore()
    }
    
    func insertQuedada() {
        //TODO: Necesito crear un for para ir iterando sobre arrayUsersID para coger cada id e irlos concatenando en un array el cual luego insertare como un campo mas en la quedada que ira a firebase
        
        guard let quedadaName = quedadaName.text else {return}
        guard let quedadaPlace = quedadaPlace.text else {return}
        
        let quedadaId = UUID().uuidString
        let docData: [String: Any] = [
            "id": quedadaId,
            "lugar": quedadaPlace,
            "nombre": quedadaName
        ]
        
        db.collection("quedadas").document(quedadaId).setData(docData) { err in
            if let err = err {
                print("Error writing user on database: \(err)")
            } else {
                Quedadas.getArrayQuedadas(userID: self.userID!, quedadaId: quedadaId, delegate: self)
                Quedadas.getArrayQuedadasAllUsers(usersID: self.arrayUsersID, quedadaId: quedadaId, delegate: self)
            }
        }
    }
    
    func getQuedadasReference(qudadasReference: Array<Any>) {
        db.collection("users").document(userID!).updateData(["quedadas": qudadasReference])
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
            // select/deselect the cell
            if itemsUsers[indexPath.row].isSelected {
                if !cell.isSelected {
                    tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                }
            } else {
                if cell.isSelected {
                    tableView.deselectRow(at: indexPath, animated: false)
                }
            }
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
