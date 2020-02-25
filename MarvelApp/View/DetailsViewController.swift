//
//  DetailsViewController.swift
//  MarvelApp
//
//  Created by Alan Silva on 23/02/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import UIKit
import SDWebImage

class DetailsViewController: BaseViewController {
    
    static let identifier = "goToDetails"
    
    var selectedCharacter : CharactersElementRealm?
    
    var controller : CharactersController?
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var starButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.detailTableView.delegate = self
        self.detailTableView.dataSource = self
        
        //Registering Cell
        self.detailTableView.register(UINib(nibName: ResourcesTableViewCell.cell, bundle: nil), forCellReuseIdentifier: ResourcesTableViewCell.cell)
        
        setupCell()
        
    }
    
    @IBAction func tapOnFavorite(_ sender: UIBarButtonItem) {
    
        //verifica status fav / percorre o array e verifica se existe
        
        if (self.controller?.isFavorite(id: self.selectedCharacter?.id ?? 0))! {
            
            let alerta = UIAlertController(title: "Aviso", message: "Personagem removido dos favoritos.", preferredStyle: .alert)
            let btnOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
            
            alerta.addAction(btnOk)
            
            self.present(alerta, animated: true)
            
            if let removeId = self.selectedCharacter?.id {
                
                self.controller?.removeFavoriteCharacter(id: removeId)
                
            }
            
            self.setFavButtonStatus()
            
        }
        else {
            
            let alerta = UIAlertController(title: "Salvo", message: "Filme \(self.selectedCharacter?.name ?? "") salvo nos favoritos.", preferredStyle: .alert)
            let btnOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
            
            alerta.addAction(btnOk)
            
            self.present(alerta, animated: true)
            
            if let selectedCharac = self.selectedCharacter {
                self.controller?.saveFavoriteCharacter(character:  selectedCharac)
            }
            
            self.setFavButtonStatus()
            
        }
        
    
    }
    
    func setFavButtonStatus(){
        if let resp = self.controller?.isFavorite(id: selectedCharacter?.id ?? 0) {
            
            if resp == true {
                self.starButton.image = UIImage(named: "MarvelLogo")
            }
            else{
                //self.starButton.setImage(#imageLiteral(resourceName: "emptyHeart_icon") , for: .normal)
            }
        }
    }
    
    func setupCell() {
        
        title = self.selectedCharacter?.name
        
        detailTableView.rowHeight = UITableViewAutomaticDimension
        detailTableView.estimatedRowHeight = 120.0
        detailTableView.layoutIfNeeded()
        
        self.descriptionLabel.text = selectedCharacter?.resultDescription
        
        if let imagem = selectedCharacter?.thumbnail {
            self.detailImageView.sd_setImage(with: URL(string: ("\(imagem)")), placeholderImage: UIImage(named: "MarvelLogo"))
        }
        
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}
        
        navBar.prefersLargeTitles = true
    }
    
}


// MARK: - Table view data source
extension DetailsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "Comics"
        case 1:
            return "Series"
        default:
            return ""
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        var nSection : Int = 0
        
        if let comics = self.selectedCharacter?.comicsItems.count {
            if comics > 0 {
                nSection += 1
            }
        }
        
        if let series = self.selectedCharacter?.seriesItems.count {
            if series > 0 {
                nSection += 1
            }
        }
        
        return nSection
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            guard let firstThreeOnly = self.selectedCharacter?.comicsItems.count else { return 0 }
            
            if firstThreeOnly > 3 {
                return 3
            }
            else {
                return self.selectedCharacter?.comicsItems.count ?? 0
            }
            
        }
        if section == 1 {
            
            guard let firstThreeOnly = self.selectedCharacter?.seriesItems.count else { return 0 }
            
            if firstThreeOnly > 3 {
                return 3
            }
            else {
                return self.selectedCharacter?.seriesItems.count ?? 0
            }
            
        }
            
        else {
            
            return 0
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : ResourcesTableViewCell = tableView.dequeueReusableCell(withIdentifier: ResourcesTableViewCell.cell, for: indexPath) as! ResourcesTableViewCell
        
        
        switch indexPath.section {
        case 0:
            cell.nameLabel.text = self.selectedCharacter?.comicsItems[indexPath.row].name
        case 1:
            cell.nameLabel.text = self.selectedCharacter?.seriesItems[indexPath.row].name
        default :
            break
        }
        
        return cell
        
    }
    
}
