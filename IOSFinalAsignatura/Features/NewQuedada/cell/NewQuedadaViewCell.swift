//
//  NewQuedadaViewCell.swift
//  IOSFinalAsignatura
//
//  Created by Manu Espeso on 05/02/2020.
//  Copyright © 2020 Manuel Espeso Martin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class NewQuedadaViewCell: UITableViewCell {
  
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userNameImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userNameImage.layer.borderWidth = 1
        userNameImage.layer.masksToBounds = false
        userNameImage.layer.borderColor = UIColor.black.cgColor
        userNameImage.layer.cornerRadius = userNameImage.frame.height/2
        userNameImage.clipsToBounds = true
        
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        accessoryType = selected ? .checkmark : .none
    }
    
    var item: ViewUserItemName? {
        didSet {
            userNameLabel.text = item?.username
        }
    }
    
    var itemImage: ViewUserItemImage? {
        didSet {
            if (self.itemImage?.image.contains("googleusercontent.com"))! {
                let fileUrl = URL(string: itemImage!.image)
                
                if let data = try? Data(contentsOf: fileUrl!) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.userNameImage.image = image
                        }
                    }
                }
            } else {
                let storage = Storage.storage()
                var reference: StorageReference!
                reference = storage.reference(forURL: self.itemImage!.image)
                reference.downloadURL { (url, error) in
                    let data = NSData(contentsOf: url!)
                    let image = UIImage(data: data! as Data)
                    
                    self.userNameImage.image = image
                }
            }
        }
    }
}
