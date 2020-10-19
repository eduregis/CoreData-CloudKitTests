//
//  Mangaka+CoreDataProperties.swift
//  CoreDataTests
//
//  Created by Eduardo Oliveira on 13/10/20.
//
//

import Foundation
import CoreData


extension Mangaka {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Mangaka> {
        return NSFetchRequest<Mangaka>(entityName: "Mangaka")
    }

    @NSManaged public var name: String?
    @NSManaged public var mangas: NSSet?

}

// MARK: Generated accessors for mangas
extension Mangaka {

    @objc(addMangasObject:)
    @NSManaged public func addToMangas(_ value: Manga)

    @objc(removeMangasObject:)
    @NSManaged public func removeFromMangas(_ value: Manga)

    @objc(addMangas:)
    @NSManaged public func addToMangas(_ values: NSSet)

    @objc(removeMangas:)
    @NSManaged public func removeFromMangas(_ values: NSSet)

}

extension Mangaka : Identifiable {

}
