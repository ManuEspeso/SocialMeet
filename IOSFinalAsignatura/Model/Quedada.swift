//
//  Quedada.swift
//  IOSFinalAsignatura
//
//  Created by Manu Espeso on 16/02/2020.
//  Copyright © 2020 Manuel Espeso Martin. All rights reserved.
//

import Foundation
import UIKit

struct Quedada {
    var id: String
    var quedadaname: String
    var quedadaplace: String
    var quedadastreet: String
    var quedadadate: String
    var quedadaimage: UIImage
    var quedadaUsers: Array<String>
}

class ViewQuedadaItem {
    private var item: Quedada
    
    var id: String {
        return item.id
    }
    
    var quedadaname: String {
        return item.quedadaname
    }
    
    var quedadaplace: String {
        return item.quedadaplace
    }
    
    var quedadastreet: String {
        return item.quedadastreet
    }
    
    var quedadadate: String {
        return item.quedadadate
    }
    
    var quedadaimage: UIImage {
        return item.quedadaimage
    }
    
    var quedadaUsers: Array<String> {
        return item.quedadaUsers
    }
    
    init(item: Quedada) {
        self.item = item
    }
}
