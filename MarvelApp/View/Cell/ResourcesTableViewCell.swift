//
//  ResourcesTableViewCell.swift
//  MarvelApp
//
//  Created by Alan Silva on 24/02/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import UIKit

class ResourcesTableViewCell: UITableViewCell {
    
    static let cell = "ResourcesTableViewCell"
    
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    
    var selectedComicsItems : CharactersElementRealm?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //setupCellDetail()
    }
    
    func setupCellDetail (){
        
        //self.nameLabel?.text = self.selectedComicsItems?.comicsItems
        
    }
    
}
