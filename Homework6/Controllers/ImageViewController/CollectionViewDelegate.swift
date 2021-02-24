//
//  CollectionViewDelegate.swift
//  Homework6
//
//  Created by spezza on 23.02.2021.
//

import UIKit

class ImagesCollectionViewDelegate: NSObject,
                                    UICollectionViewDelegate,
                                    UICollectionViewDelegateFlowLayout {

    var onSelectItem: (IndexPath) -> Void

    init(onSelectItem: @escaping (IndexPath) -> Void) {
        self.onSelectItem = onSelectItem
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onSelectItem(indexPath)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width: CGFloat

        if UIDevice.current.orientation.isLandscape {
            width = collectionView.bounds.width / 2 - 1.5
        } else {
            width = collectionView.bounds.width / 2 - 1.5
        }

        return CGSize(width: width, height: width)
    }
}
