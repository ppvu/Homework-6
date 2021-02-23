//
//  Factory.swift
//  Homework6
//
//  Created by spezza on 21.02.2021.
//

import CoreData

class Factory {
    static private var stack = CoreDataStack.shared
    static private var container = stack.container
    static private var viewContext = container.viewContext
}

enum FactoryError: Error {

    case objectAllocation
    case contextSaving
    case contextSync
}

extension Factory {
    public static func makeImage(
        with imageData: ImageDataForDownload,
        completion: ((Result<CoreImage, FactoryError>) -> Void)? = nil) {

        let context = container.newBackgroundContext()
        context.perform {
            guard let image = NSEntityDescription
                    .insertNewObject(forEntityName: "CoreImage", into: context) as? CoreImage else {
                viewContext.perform {
                    completion?(.failure(.objectAllocation))
                }
                return
            }

            image.data = imageData.data
            image.name = imageData.name

            do {
                try context.save()
            } catch {
                viewContext.perform {
                    completion?(.failure(.contextSaving))
                }
                return
            }

            viewContext.perform {
                guard let result = try? viewContext.existingObject(with: image.objectID) as? CoreImage else {
                    completion?(.failure(.contextSync))
                    return
                }
                completion?(.success(result))
            }
        }
    }
}
