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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.controller.loadUpFavorites()
        
        //CollectionView Methods
        self.favoriteCollectionView.delegate = self
        self.favoriteCollectionView.dataSource = self
        
        //Registering Cell
        self.favoriteCollectionView.register(UINib(nibName: CustomCollectionViewCell.cell, bundle: nil), forCellWithReuseIdentifier: CustomCollectionViewCell.cell)
        
    }

}

extension FavoritesViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        self.controller.getNumberOfFavorites()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.cell, for: indexPath) as! CustomCollectionViewCell
        
        //cell.characterProfile = self.controller.getCharacterWithIndexPath(indexPath)
        
        cell.myLabel.text = "\(indexPath)"
        
        //cell.delegate = self
        
        return cell
        
    }
    
}
