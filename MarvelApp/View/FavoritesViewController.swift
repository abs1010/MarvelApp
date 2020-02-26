//
//  FavoritesViewController.swift
//  MarvelApp
//
//  Created by Alan Silva on 25/02/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import UIKit

class FavoritesViewController: BaseViewController {
    
    let controller = CharactersController()

    @IBOutlet weak var favoriteCollectionView: UICollectionView!
    
    var refreshControl: UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addRefreshingControl()
        
        //LOADS AND FILTER THE FAVORITES
        //self.controller.loadUpFavorites()
        
        //CollectionView Methods
        self.favoriteCollectionView.delegate = self
        self.favoriteCollectionView.dataSource = self
        
        //Registering Cell
        self.favoriteCollectionView.register(UINib(nibName: CustomCollectionViewCell.cell, bundle: nil), forCellWithReuseIdentifier: CustomCollectionViewCell.cell)
        
        setLayout(for: favoriteCollectionView)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        //self.addRefreshingControl()
        
        self.controller.loadUpFavorites()
        self.favoriteCollectionView.reloadData()
        
    }
    
    func addRefreshingControl(){
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.tintColor = .red
        self.refreshControl?.addTarget(self, action: #selector(refreshList), for: .valueChanged)
        self.favoriteCollectionView.addSubview(refreshControl!)
        
    }
        
    @objc func refreshList() {
        
        self.refreshControl?.endRefreshing()
        self.controller.loadUpFavorites()
        self.favoriteCollectionView.reloadData()
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == DetailsViewController.identifier {
            
            if let vc: DetailsViewController = segue.destination as? DetailsViewController {
                
                vc.selectedCharacter = self.controller.getCharacterWithIndexPathForFavorite()
                vc.indexPath = self.controller.getSelectedIndexForFavorite()
            }
            
        }
        
    }
    
}

extension FavoritesViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        self.controller.getNumberOfFavorites()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.cell, for: indexPath) as! CustomCollectionViewCell
        
        cell.characterProfile = self.controller.getCharacterWithIndexPathOfFavorites(indexPath)
        
        cell.delegate = self
        
        return cell
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let padding: CGFloat =  50
//        let collectionViewSize = collectionView.frame.size.width - padding
//
//        return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.controller.saveIndexForSelectedFavorite(index: indexPath.row)
        performSegue(withIdentifier: DetailsViewController.identifier, sender: self)
        
    }
    
}

//MARK: - EXTENSION OF CUSTONCLCELL TO GET CHANGES ON FAVORITE STATUS
extension FavoritesViewController : CustomCollectionViewCellDelegate {
    
    func setCharacterAsFavorite() {
        
        DispatchQueue.main.async {
            self.favoriteCollectionView.reloadData()
            print("Passei ai rapaz")
        }
        
    }

}
