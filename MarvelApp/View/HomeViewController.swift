//
//  ViewController.swift
//  MarvelApp
//
//  Created by Alan Silva on 17/02/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: BaseViewController {
    
    let controller = CharactersController()
    
    @IBOutlet weak var charactersCollectionView: UICollectionView!
    
    var refreshControl: UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.addRefreshingControl()
        
        //Initializes the controller and makes the first request
        controller.setupController(offSet: 0)
        
        self.controller.delegate = self
        
        //CollectionView Methods
        self.charactersCollectionView.delegate = self
        self.charactersCollectionView.dataSource = self
        
        //Registering Cell
        self.charactersCollectionView.register(UINib(nibName: CustomCollectionViewCell.cell, bundle: nil), forCellWithReuseIdentifier: CustomCollectionViewCell.cell)
        
        setLayout(for: charactersCollectionView)
        startActivityIndicator()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == DetailsViewController.identifier {
            
            if let vc: DetailsViewController = segue.destination as? DetailsViewController {
                
                vc.selectedCharacter = self.controller.getCharacterWithIndexPathFromItem()
                vc.indexPath = self.controller.getSelectedIndex()
            }
            
        }
        
    }
    
    @IBAction func getMoreData(_ sender: UIBarButtonItem) {
        
        //CREATE A TEMP METHOD TO CALL THE CLOSURE
        startActivityIndicator()
        self.controller.requestAnotherPage(currentCounter: 40)
        
    }
    
    func addRefreshingControl(){
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.tintColor = .red
        self.refreshControl?.addTarget(self, action: #selector(refreshList), for: .valueChanged)
        self.charactersCollectionView.addSubview(refreshControl!)
        
    }
    
    @objc func refreshList() {
        
        self.refreshControl?.endRefreshing()
        //add new request
        self.charactersCollectionView.reloadData()
        
    }
    
}

extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.controller.getNumberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.cell, for: indexPath) as! CustomCollectionViewCell
        
        cell.characterProfile = self.controller.getCharacterWithIndexPath(indexPath)
        
        cell.delegate = self
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding: CGFloat =  50
        let collectionViewSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        print(controller.indexIsLast(indexPath.item))
        
        //controller.requestAnotherPage(currentCounter: indexPath.item)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.controller.saveIndexSelected(index: indexPath.row)
        performSegue(withIdentifier: DetailsViewController.identifier, sender: self)
        
    }
    
}

//MARK: - EXTENSION OF VIEWCONTROLLER (CONTROLLERDELEGATE)
extension HomeViewController : CharactersControllerDelegate {
    
    func successOnFethingCharactersOfPageOffet() {
        
        DispatchQueue.main.async {
            self.charactersCollectionView.reloadData()
            
            self.stopActivityIndicator()
        }
        
    }
    
    func errorOnFethingCharacters(error: Error) {
        
    }
    
}

//MARK: - EXTENSION OF CUSTONCLCELL TO GET CHANGES ON FAVORITE STATUS
extension HomeViewController : CustomCollectionViewCellDelegate {
    
    func setCharacterAsFavorite() {
        
        DispatchQueue.main.async {
            //self.charactersCollectionView.reloadData()
        }
        
    }

}
