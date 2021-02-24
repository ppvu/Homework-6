//
//  Image.swift
//  Homework6
//
//  Created by spezza on 22.02.2021.
//

import UIKit

class Image: UICollectionViewCell {
    
    @IBOutlet weak private var imageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image = nil
    }
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
}
