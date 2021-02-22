//
//  ImagesViewController.swift
//  Homework6
//
//  Created by spezza on 21.02.2021.
//

import UIKit
import CoreData
import SwiftKeychainWrapper

class ImagesViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Memes Library"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = #colorLiteral(red: 0.3998196111, green: 1, blue: 0.7727912969, alpha: 1)
        
    }
}

extension ImagesViewController {
    
    func setupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out",
                            style: .plain,
                            target: self,
                            action: #selector(logOut))
    }
    
    @objc func logOut() {
    }
}
