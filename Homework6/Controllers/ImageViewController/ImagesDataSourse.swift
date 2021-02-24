//
//  ImagesDataSourse.swift
//  Homework6
//
//  Created by spezza on 23.02.2021.
//

import Foundation
import CoreData
import UIKit

class ImagesDataSource: UICollectionViewFetchedResultsController<CoreImage> {

    private let cellClass: Image.Type
    private let context: NSManagedObjectContext

    init(at context: NSManagedObjectContext,
         for collectionView: UICollectionView,
         displayng cellClass: Image.Type) {

        self.cellClass = cellClass
        self.context = context

        let frc = ImagesFetchResultsController.make(at: context)
        super.init(with: collectionView, and: frc)

        do {
            try frc.performFetch()
        } catch {
            print(error)
        }
    }
}

extension ImagesDataSource: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        frc.sections?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        let numberOfItems: Int

        if let sectionInfo = frc.sections?[section] {
            numberOfItems = sectionInfo.numberOfObjects
        } else {
            numberOfItems = 0
        }

        return numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let object = frc.object(at: indexPath)
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: cellClass.reuseIdOrClassName,
                for: indexPath) as? Image else {
            fatalError("Could not cast cell as ImageCell")
        }

        cell.image = object.image

        return cell
    }
}
