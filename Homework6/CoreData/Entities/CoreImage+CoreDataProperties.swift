//
//  CoreImage+CoreDataProperties.swift
//  Homework6
//
//  Created by spezza on 21.02.2021.
//
//

import Foundation
import CoreData


extension CoreImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreImage> {
        return NSFetchRequest<CoreImage>(entityName: "CoreImage")
    }

    @NSManaged public var data: Data?
    @NSManaged public var name: String?
    @NSManaged public var sha: String?

}

extension CoreImage : Identifiable {

}
