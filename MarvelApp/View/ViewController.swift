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
        
        //Initializes the controller and makes the first request
        controller.setupController(offSet: 20)
        
        self.controller.delegate = self
        
        //CollectionView Methods
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
 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == DetailsViewController.identifier {
            
            if let vc: DetailsViewController = segue.destination as? DetailsViewController {
  
                
            if let indexPath = charactersCollectionView.indexPathsForSelectedItems {
                print("Clicou no \(indexPath[0].item)")
                vc.selectedCharacter = self.controller.getCharacterWithIndexPathItem(index: indexPath[0])
                
            }
//                if let indexPath = charactersCollectionView.indexPathsForSelectedItems {
//                    vc.selectedCharacter = self.controller.getCharacterWithIndexPathItem(index: indexPath[0].item)
//                }
                
            }
            
        }
        
    }
    
    @IBAction func getMoreData(_ sender: UIBarButtonItem) {
        
        
    }
    
}

extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.controller.getNumberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.cell, for: indexPath) as! CustomCollectionViewCell
        
        cell.characterProfile = self.controller.getCharacterWithIndexPath(indexPath)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding: CGFloat =  50
        let collectionViewSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        print(controller.indexIsLast(indexPath.item))
        
        controller.requestAnotherPage(currentCounter: indexPath.item)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: DetailsViewController.identifier, sender: self)
        
    }
    
}

//MARK: - EXTENSION OF VIEWCONTROLLER (CONTROLLERDELEGATE)
extension ViewController : CharactersControllerDelegate {
    
    func successOnFethingCharactersOfPageOffet() {
        
        DispatchQueue.main.async {
            self.charactersCollectionView.reloadData()
            
            self.stopActivityIndicator()
        }
        
    }
    
    func errorOnFethingCharacters(error: Error) {
        
    }
    
}
