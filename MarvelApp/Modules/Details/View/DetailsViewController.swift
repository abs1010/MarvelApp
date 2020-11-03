//
//  DetailsViewController.swift
//  MarvelApp
//
//  Created by Alan Silva on 23/02/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import UIKit
import SDWebImage
import RealmSwift

class DetailsViewController: BaseViewController {
    
    static let identifier = "goToDetails"
    
    var selectedCharacter : CharactersElementRealm?
    var indexPath : Int?
    private let realm = try! Realm()
    var controller : CharactersController?
    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var favoriteView: UIView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.controller = CharactersController()
        
        self.detailTableView.delegate = self
        self.detailTableView.dataSource = self
        
        //Registering Cell
        self.detailTableView.register(UINib(nibName: ResourcesTableViewCell.cell, bundle: nil), forCellReuseIdentifier: ResourcesTableViewCell.cell)
        
        setupCell()
        
    }
    
    @IBAction func tapOnFavorite(_ sender: UIButton) {
        
        sender.pulse()
        
        if let item = self.selectedCharacter {
            
            do{
                try realm.write {
                    item.favorite = !item.favorite
                }
            }
            catch{
                print("Erro ao remover registro : \(error)")
            }
            
            setStarStatus()
        }
        
    }
    
    private func setupCell() {
        
        setStarStatus()
        
        title = self.selectedCharacter?.name
        
        detailTableView.rowHeight = UITableViewAutomaticDimension
        detailTableView.estimatedRowHeight = 120.0
        detailTableView.layoutIfNeeded()
        
        self.descriptionLabel.text = selectedCharacter?.resultDescription
        
        if descriptionLabel.text?.count == 0 {
            topConstraint.constant = 0
            bottomConstraint.constant = 0
        }
        
        if let imagem = selectedCharacter?.thumbnail {
            self.detailImageView.sd_setImage(with: URL(string: ("\(imagem)")), placeholderImage: UIImage(named: "MarvelLogo"))
        }
        
        favoriteView.layer.borderColor = UIColor.black.cgColor
        favoriteView.layer.borderWidth = 0.5
        
    }
    
    private func setStarStatus(){
        
        if let item = self.selectedCharacter {
            if item.favorite {
                favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            }
            else{
                favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
            }
            
        }
        
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
            
//            guard let firstThreeOnly = self.selectedCharacter?.comicsItems.count else { return 0 }
            
//            if firstThreeOnly > 3 {
//                return 3
//            }
//            else {
                return self.selectedCharacter?.comicsItems.count ?? 0
//            }
            
        }
        if section == 1 {
            
//            guard let firstThreeOnly = self.selectedCharacter?.seriesItems.count else { return 0 }
            
//            if firstThreeOnly > 3 {
//                return 3
//            }
//            else {
                return self.selectedCharacter?.seriesItems.count ?? 0
 //           }
            
        }
        
        else {
            
            return 0
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : ResourcesTableViewCell = tableView.dequeueReusableCell(withIdentifier: ResourcesTableViewCell.cell, for: indexPath) as! ResourcesTableViewCell
        
        
        let name = indexPath.section == 0 ? self.selectedCharacter?.comicsItems[indexPath.row].name : self.selectedCharacter?.seriesItems[indexPath.row].name
        
        cell.nameLabel.text = name
        
        //let image : String = (indexPath.section == 0 ? self.selectedCharacter?.comicsItems[indexPath.row].resourceURI : self.selectedCharacter?.seriesItems[indexPath.row].resourceURI)!
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}
