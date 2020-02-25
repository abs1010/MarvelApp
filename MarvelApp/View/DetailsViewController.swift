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
    let realm = try! Realm()
    var controller : CharactersController?
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var starButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.controller = CharactersController()
        
        self.detailTableView.delegate = self
        self.detailTableView.dataSource = self
        
        //Registering Cell
        self.detailTableView.register(UINib(nibName: ResourcesTableViewCell.cell, bundle: nil), forCellReuseIdentifier: ResourcesTableViewCell.cell)
        
        setupCell()
        
    }
    
    @IBAction func tapOnFavorite(_ sender: UIBarButtonItem) {
        
        if let item = self.selectedCharacter {
            
            let icon = item.favorite ? "favoritado" : "nao favorite"
            print("====Favorite Status Changed on Realm ====")
            print(icon)
            
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
    
    func setupCell() {
        
        setStarStatus()
        
        title = self.selectedCharacter?.name
        
        detailTableView.rowHeight = UITableViewAutomaticDimension
        detailTableView.estimatedRowHeight = 120.0
        detailTableView.layoutIfNeeded()
        
        self.descriptionLabel.text = selectedCharacter?.resultDescription
        
        if let imagem = selectedCharacter?.thumbnail {
            self.detailImageView.sd_setImage(with: URL(string: ("\(imagem)")), placeholderImage: UIImage(named: "MarvelLogo"))
        }
        
    }
    
    func setStarStatus(){
        
        if let item = self.selectedCharacter {
            if item.favorite {
                self.navigationItem.rightBarButtonItem?.setBackgroundImage(UIImage(named: "filledStar"), for: .normal, barMetrics: .default)
            }
            else{
                self.navigationItem.rightBarButtonItem?.setBackgroundImage(UIImage(named: "emptyStar"), for: .normal, barMetrics: .default)
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
        
        
        let name = indexPath.section == 0 ? self.selectedCharacter?.comicsItems[indexPath.row].name : self.selectedCharacter?.seriesItems[indexPath.row].name
        
        cell.nameLabel.text = name
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}
