//
//  ViewController.swift
//  MarvelApp
//
//  Created by Alan Silva on 17/02/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import UIKit
import CoreData

class ViewController: BaseViewController {
    
    let controller = CharactersController()
    
    @IBOutlet weak var charactersCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        controller.setupController(offSet: 20)
        
        self.controller.delegate = self
        
        self.charactersCollectionView.delegate = self
        self.charactersCollectionView.dataSource = self
        
        //Registering Cell
        self.charactersCollectionView.register(UINib(nibName: CustomCollectionViewCell.cell, bundle: nil), forCellWithReuseIdentifier: CustomCollectionViewCell.cell)
        
        setLayout()
        
        startActivityIndicator()
    }
    
    func setLayout(){
        
        let layout = self.charactersCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsetsMake(5, 15, 5, 15)
        layout.minimumInteritemSpacing = 15
        layout.minimumLineSpacing = 15
        layout.itemSize = CGSize(width: self.charactersCollectionView.frame.size.width - 20/2, height: self.charactersCollectionView.frame.size.height / 3)
        
    }
    
}

extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.controller.getNumberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.cell, for: indexPath) as! CustomCollectionViewCell
        
        cell.characterProfile = self.controller.getCharacterWithIndexPath(_index: indexPath)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let padding: CGFloat =  50
        let collectionViewSize = collectionView.frame.size.width - padding

        return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
    }
    
}

//MARK: - EXTENSION OF VIEWCONTROLLER (CONTROLLERDELEGATE)
extension ViewController : CharactersControllerDelegate {
    
    func successOnFethingCharactersOfPageOffet(offset: Int) {
        
        DispatchQueue.main.async {
            self.charactersCollectionView.reloadData()
            self.stopActivityIndicator()
        }
        
    }
    
    func errorOnFethingCharacters(error: Error) {
        
    }
    
}
