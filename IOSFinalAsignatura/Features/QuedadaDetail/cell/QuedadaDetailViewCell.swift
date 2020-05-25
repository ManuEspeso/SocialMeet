//
//  QuedadaDetailViewCell.swift
//  IOSFinalAsignatura
//
//  Created by Manu Espeso on 15/02/2020.
//  Copyright © 2020 Manuel Espeso Martin. All rights reserved.
//

import UIKit

class QuedadaDetailViewCell: UITableViewCell { 
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userNameImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userNameImage.layer.borderWidth = 1
        userNameImage.layer.masksToBounds = false
        userNameImage.layer.borderColor = UIColor.black.cgColor
        userNameImage.layer.cornerRadius = userNameImage.frame.height/2
        userNameImage.clipsToBounds = true
    }
}
