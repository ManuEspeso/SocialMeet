//
//  Model.swift
//  IOSFinalAsignatura
//
//  Created by Manu Espeso on 05/02/2020.
//  Copyright © 2020 Manuel Espeso Martin. All rights reserved.
//

import Foundation

struct UserName {
    var id: String
    var username: String
}

class ViewUserItemName {
    private var item: UserName
    
    var isSelected = false
    
    var id: String {
        return item.id
    }
    
    var username: String {
        return item.username
    }
    
    init(item: UserName) {
        self.item = item
    }
}


struct UserImage {
    var id: String
    var image: String
}

class ViewUserItemImage {
    private var item: UserImage
    
    var isSelected = false
    
    var id: String {
        return item.id
    }
    
    var image: String {
        return item.image
    }
    
    init(item: UserImage) {
        self.item = item
    }
}
