//
//  NewQuedadaViewCell.swift
//  IOSFinalAsignatura
//
//  Created by Manu Espeso on 05/02/2020.
//  Copyright © 2020 Manuel Espeso Martin. All rights reserved.
//

import UIKit

class NewQuedadaViewCell: UITableViewCell {
  
    @IBOutlet weak var userNameLabel: UILabel!
    
    var item: ViewUserItem? {
        didSet {
            userNameLabel.text = item?.username
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        accessoryType = selected ? .checkmark : .none
    }
}
