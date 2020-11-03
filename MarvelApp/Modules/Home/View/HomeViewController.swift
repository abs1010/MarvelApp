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
    private var isFethingNewPage = false
    
    @IBOutlet weak var charactersCollectionView: UICollectionView!
    
    var refreshControl: UIRefreshControl?
    
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        registerCells()
        
        self.addRefreshingControl()
        
        //Initializes the controller and makes the first request
        controller.setupController()
        
        self.controller.delegate = self
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        startActivityIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.charactersCollectionView.reloadData()
        
    }
    
    private func registerCells() {
        
        //CollectionView Methods
        self.charactersCollectionView.delegate = self
        self.charactersCollectionView.dataSource = self
        
        //Registering Cell
        self.charactersCollectionView.register(UINib(nibName: CustomCollectionViewCell.cell, bundle: nil), forCellWithReuseIdentifier: CustomCollectionViewCell.cell)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == DetailsViewController.identifier {
            
            if let vc: DetailsViewController = segue.destination as? DetailsViewController {
                
                vc.selectedCharacter = self.controller.getCharacterWithIndexPathFromItem()
                vc.indexPath = self.controller.getSelectedIndex()
            }
            
        }
        
    }
    
    //MARK: - Fetch More Pages
    private func startFetchingNewPage() {
        
        if isFethingNewPage {
            print("Another request is already under way")
        }else {
            
            isFethingNewPage = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
                
                self.startActivityIndicator()
                self.controller.requestAnotherPage()
                
            })
            
        }
        
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

extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.controller.getNumberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.cell, for: indexPath) as! CustomCollectionViewCell
        
        cell.characterProfile = self.controller.getCharacterWithIndexPath(indexPath)
        
        cell.delegate = self
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.controller.saveIndexSelected(index: indexPath.row)
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard scrollView.isDragging else {return}
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollFrameHeight = scrollView.frame.height
        
        if offsetY > (contentHeight - scrollFrameHeight) {
            
            if !isFethingNewPage {
                startFetchingNewPage()
            }
            
        }
        
    }
    
}

//MARK: - EXTENSION OF VIEWCONTROLLER (CONTROLLERDELEGATE)
extension HomeViewController : CharactersControllerDelegate {
    
    func successOnFethingCharactersOfPageOffet() {
        
        DispatchQueue.main.async {
            self.charactersCollectionView.reloadData()
            self.stopActivityIndicator()
            self.isFethingNewPage = false
        }
        
    }
    
    func errorOnFethingCharacters(error: Error) {
        
        showAlert(title: "Aviso", msg: "Parece que você está sem conexão. Sem dados locais.")
        
        stopActivityIndicator()
        
    }
    
    func limitOfRequestsHasBeenReached(){
        
        showAlert(title: "Aviso", msg: "Você chegou ao fim da lista")
        stopActivityIndicator()
        
    }
    
}

//MARK: - EXTENSION OF CUSTONCLCELL TO GET CHANGES ON FAVORITE STATUS
extension HomeViewController : CustomCollectionViewCellDelegate {
    
    func setCharacterAsFavorite() {
        
        DispatchQueue.main.async {
            //self.charactersCollectionView.reloadData()
            //self.charactersCollectionView.scrollsToTop = false
        }
        
    }
    
}
