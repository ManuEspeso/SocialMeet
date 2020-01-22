//
//  Quedada.swift
//  IOSFinalAsignatura
//
//  Created by Manu Espeso on 22/01/2020.
//  Copyright © 2020 Manuel Espeso Martin. All rights reserved.
//

import Foundation

public class Quedada {
    
    var name: String?
    var place: String?
    
    convenience init(name: String? = nil, place: String? = nil) {
        self.init()
        
        self.name = name
        self.place = place
    }
}
