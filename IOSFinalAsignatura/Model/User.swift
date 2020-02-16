//
//  Model.swift
//  IOSFinalAsignatura
//
//  Created by Manu Espeso on 05/02/2020.
//  Copyright © 2020 Manuel Espeso Martin. All rights reserved.
//

import Foundation

struct User {
    var id: String
    var username: String
}

class ViewUserItem {
    private var item: User
    
    var isSelected = false
    
    var id: String {
        return item.id
    }
    
    var username: String {
        return item.username
    }
    
    init(item: User) {
        self.item = item
    }
}
