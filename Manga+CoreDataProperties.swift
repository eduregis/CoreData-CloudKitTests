//
//  Manga+CoreDataProperties.swift
//  CoreDataTests
//
//  Created by Eduardo Oliveira on 13/10/20.
//
//

import Foundation
import CoreData


extension Manga {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Manga> {
        return NSFetchRequest<Manga>(entityName: "Manga")
    }

    @NSManaged public var demography: String?
    @NSManaged public var name: String?

}

extension Manga : Identifiable {

}
