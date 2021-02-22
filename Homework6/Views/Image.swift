//
//  Image.swift
//  Homework6
//
//  Created by spezza on 22.02.2021.
//

import UIKit

class Image: UICollectionViewCell {
    
    @IBOutlet weak private var imageView: UIImageView!
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image = nil
    }
}
