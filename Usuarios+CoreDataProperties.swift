//
//  Usuarios+CoreDataProperties.swift
//  
//
//  Created by Manu Espeso on 16/02/2020.
//
//

import Foundation
import CoreData


extension Usuarios {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Usuarios> {
        return NSFetchRequest<Usuarios>(entityName: "Usuarios")
    }

    @NSManaged public var email: String?
    @NSManaged public var id: String?

}
