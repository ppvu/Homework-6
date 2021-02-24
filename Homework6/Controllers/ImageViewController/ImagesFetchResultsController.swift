//
//  ImagesFetchResultsController.swift
//  Homework6
//
//  Created by spezza on 23.02.2021.
//

import CoreData

class ImagesFetchResultsController: NSFetchedResultsController<CoreImage> {

    class func make(at context: NSManagedObjectContext) -> ImagesFetchResultsController {

        let request: NSFetchRequest<CoreImage> = CoreImage.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(CoreImage.name),
                                    ascending: true, selector: #selector(NSString.caseInsensitiveCompare))

        request.sortDescriptors = [sort]
        let result = ImagesFetchResultsController(fetchRequest: request,
                               managedObjectContext: context,
                               sectionNameKeyPath: nil,
                               cacheName: nil)
        return result
    }
}
