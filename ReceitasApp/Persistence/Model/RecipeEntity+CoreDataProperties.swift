//
//  RecipeEntity+CoreDataProperties.swift
//  
//
//  Created by Luan Damato on 02/11/25.
//
//

import Foundation
import CoreData


extension RecipeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeEntity> {
        return NSFetchRequest<RecipeEntity>(entityName: "RecipeEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var description_: String?
    @NSManaged public var images: NSObject?
    @NSManaged public var ingredients: NSObject?
    @NSManaged public var owner: String?
    @NSManaged public var ownerId: String?
    @NSManaged public var date: String?
    @NSManaged public var preparation: String?

}
