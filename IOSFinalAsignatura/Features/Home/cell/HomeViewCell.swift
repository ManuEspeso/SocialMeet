//
//  CollectionViewCell.swift
//  IOSFinalAsignatura
//
//  Created by Manu Espeso on 25/12/2019.
//  Copyright © 2019 Manuel Espeso Martin. All rights reserved.
//

import UIKit

class HomeViewCell: UICollectionViewCell {
    
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var locationDescription: UILabel!
    
    var item: ViewQuedadaItem? {
        didSet {
            locationImage.image = item?.quedadaimage
            locationName.text = item?.quedadaname
            locationDescription.text = item?.quedadadate
        }
    }
}
