//
//  BaseViewController.swift
//  MarvelApp
//
//  Created by Alan Silva on 20/02/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    private lazy var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func startActivityIndicator(){
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        //activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorView.Style.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator(){
        activityIndicator.stopAnimating()
    }

    func showAlert(title: String, msg: String) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let btnOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(btnOk)
        
        self.present(alert, animated: true)
        
    }
    
    //MARK: - SETS LAYOUT FOR COLLECTION VIEW
    
    func setLayout(for collection: UICollectionView){
         
         let layout = collection.collectionViewLayout as! UICollectionViewFlowLayout
         layout.sectionInset = UIEdgeInsetsMake(5, 15, 5, 15)
         layout.minimumInteritemSpacing = 15
         layout.minimumLineSpacing = 15
         layout.itemSize = CGSize(width: collection.frame.size.width - 20/2, height: collection.frame.size.height / 3)
         
         guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}
         
         navBar.prefersLargeTitles = true
         
     }
    
    //Pull to Refresh
//
//    func addRefreshingControlA(for collection: UICollectionView){
//
//        var refreshControl: UIRefreshControl?
//
//        refreshControl = UIRefreshControl()
//        refreshControl?.tintColor = .red
//        refreshControl?.addTarget(self, action: #selector(refreshList), for: .valueChanged)
//        collection.addSubview(refreshControl!)
//
//    }
    
}
