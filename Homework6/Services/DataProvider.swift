//
//  DataProvider.swift
//  Homework6
//
//  Created by spezza on 23.02.2021.
//

import Foundation
import CoreData

class DataProvider {
    private let persistentContainer: NSPersistentContainer
    private let apiService: API
    
    private var fetchingImages: Bool = false
    
    private var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(persistentContainer: NSPersistentContainer, apiService: API) {
        self.persistentContainer = persistentContainer
        self.apiService = apiService
    }
    
    public func clearStorage() {
        let taskContext = persistentContainer.newBackgroundContext()
        
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreImage")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            _ = try? taskContext.execute(batchDeleteRequest)
        }
    }
    
    public func fetchImages(completion: (() -> Void)? = nil) {
        
        guard !fetchingImages else {
            completion?()
            return
        }
        
        fetchingImages = true
        
        apiService.getInfo { result in
            switch result {
            case .success(let imagesInfos):
                self.removeDifferences(imagesInfos: imagesInfos) { remaining in
                    if remaining.count == 0 {
                        self.fetchingImages = false
                        completion?()
                        return
                    }
                    self.fetchImagesFromApi(imagesInfos: remaining) { [weak self] in
                        self?.fetchingImages = false
                        completion?()
                    }
                }
            case .failure(let error):
                self.fetchingImages = false
                completion?()
                print(error)
            }
        }
    }
    
    private func fetchImagesFromApi(imagesInfos: [ImageInfo], completion: (() -> Void)? = nil) {
        
        let group = DispatchGroup()
        
        for imageInfo in imagesInfos {
            group.enter()
            
            apiService.fetchImage(with: imageInfo) { result in
                switch result {
                case .success(let imageData):
                    Factory.makeImage(with: imageData)
                    group.leave()
                case .failure(let error):
                    print(error)
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                completion?()
            }
        }
    }
}

private extension DataProvider {
    
    func removeDifferences(imagesInfos: [ImageInfo], completion: @escaping ([ImageInfo]) -> Void) {
        let taskContext = persistentContainer.newBackgroundContext()
        var remaining = imagesInfos
        
        taskContext.performAndWait {
            let currentImagesRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreImage")
            
            do {
                guard let currentImages = try taskContext.fetch(currentImagesRequest) as? [CoreImage] else {
                    return
                }
                
                var differences = [CoreImage]()
                
                currentImages.forEach { coreImage in
                    guard let imageInfo = imagesInfos.first(where: { $0.sha == coreImage.sha }) else {
                        differences.append(coreImage)
                        return
                    }
                    
                    if imageInfo.name != coreImage.name {
                        differences.append(coreImage)
                        return
                    }
                    
                    guard let index = remaining.firstIndex(where: { $0.sha == coreImage.sha }) else {
                        return
                    }
                    
                    remaining.remove(at: index)
                }
                
                differences.forEach { taskContext.delete($0) }
                try? taskContext.save()
                
                completion(remaining)
            } catch {
                print("Error: \(error)\nCould not batch delete existing records.")
            }
        }
    }
}

