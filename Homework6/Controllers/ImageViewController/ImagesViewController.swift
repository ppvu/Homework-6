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
    
    public var logoutCallback: (() -> ())?
    

    private let context: NSManagedObjectContext = CoreDataStack.shared.container.viewContext
    private var dataSource: ImagesDataSource?
    private var dataProvider: DataProvider?
    lazy private var refreshControl = UIRefreshControl()
    
    lazy private var collectionViewDelegate = ImagesCollectionViewDelegate { [weak self] in
        self?.imageSelected(at: $0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Memes Library"
        collectionView.backgroundColor = #colorLiteral(red: 0.5308901072, green: 1, blue: 0.6132929344, alpha: 1)
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
        prepareCollectionView()
        prepareDataSource()
        prepareDataProvider()
        setupNavigationBar()
        setupRefreshControl()

        reloadData()
    }
}

private extension ImagesViewController {

    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Log Out", style: .plain, target: self, action: #selector(logout))
    }
    
    func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        refreshControl.backgroundColor = #colorLiteral(red: 0.5320955515, green: 0.9986847043, blue: 0.6130190492, alpha: 1)
        collectionView.addSubview(refreshControl)
    }

    @objc func logout() {
        dataProvider?.clearStorage()

        self.logoutCallback?()
        navigationController?.dismiss(animated: true)
    }

    func prepareCollectionView() {

        let identifier = Image.reuseIdOrClassName

        collectionView.delegate = collectionViewDelegate

        collectionView.register(
            UINib(nibName: identifier, bundle: .main),
            forCellWithReuseIdentifier: identifier)
    }

    func prepareDataSource() {

        dataSource = ImagesDataSource(
            at: context,
            for: collectionView,
            displayng: Image.self)

        collectionView.dataSource = dataSource
        collectionView.reloadData()
    }

    func prepareDataProvider() {
        dataProvider = DataProvider(
            persistentContainer: CoreDataStack.shared.container,
            apiService: API())
    }

    @objc func reloadData() {

        refreshControl.beginRefreshing()
        self.dataProvider?.fetchImages { [weak self] in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
            }
        }
    }

    func imageSelected(at indexPath: IndexPath) {
        guard let coreImage = dataSource?.frc.object(at: indexPath) else {
            return
        }

        let detailedImageVC =
            FullScreenViewController(nibName: "FullScreenViewController", bundle: nil)
        detailedImageVC.coreImage = coreImage
        navigationController?.pushViewController(detailedImageVC, animated: true)
    }
}
