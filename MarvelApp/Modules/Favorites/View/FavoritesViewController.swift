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
        
        registerCells()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        //self.addRefreshingControl()
        
        self.controller.loadUpFavorites()
        self.favoriteCollectionView.reloadData()
        
    }
    
    private func registerCells() {
        
        //CollectionView Methods
        self.favoriteCollectionView.delegate = self
        self.favoriteCollectionView.dataSource = self
        
        //Registering Cell
        self.favoriteCollectionView.register(UINib(nibName: CustomCollectionViewCell.cell, bundle: nil), forCellWithReuseIdentifier: CustomCollectionViewCell.cell)
        
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

extension FavoritesViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        self.controller.getNumberOfFavorites()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.cell, for: indexPath) as! CustomCollectionViewCell
        
        cell.characterProfile = self.controller.getCharacterWithIndexPathOfFavorites(indexPath)
        
        cell.delegate = self
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.controller.saveIndexForSelectedFavorite(index: indexPath.row)
        performSegue(withIdentifier: DetailsViewController.identifier, sender: self)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return CGSize(width: (view.frame.width / 3) - 8, height: 180)
        case .pad:
            return CGSize(width: view.frame.width / 3.4 , height: view.frame.height / 4)
        case .tv:
            break
        case .carPlay:
            break
        case .mac:
            break
        case .unspecified:
            break
        }
        
        return CGSize(width: 100, height: 120)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return .init(top: 6.0, left: 6.0, bottom: 6.0, right: 6.0)

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .init(2.0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .init(6.0)
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
