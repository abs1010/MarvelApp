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
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.detailTableView.delegate = self
        self.detailTableView.dataSource = self
        
        setupCell()
        
    }
    
    func setupCell() {
        
        title = self.selectedCharacter?.name
        
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
            
            return self.selectedCharacter?.comicsItems.count ?? 0
            
        }
        if section == 1 {
            
            return self.selectedCharacter?.seriesItems.count ?? 0
        }
        
        else {
            
            return 0
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
        
    }
    
}
