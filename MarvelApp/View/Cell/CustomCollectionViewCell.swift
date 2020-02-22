//
//  CustomCollectionViewCell.swift
//  MarvelApp
//
//  Created by Alan Silva on 21/02/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import UIKit
import SDWebImage

class CustomCollectionViewCell: UICollectionViewCell {
    
    static let cell = "CustomCollectionViewCell"
    
    var characterProfile : CharactersElementRealm! {
        
        didSet {
            self.myLabel.text = characterProfile.name
            self.myImageView.sd_setImage(with: URL(string: ("\(characterProfile.thumbnail)")), placeholderImage: UIImage(named: "MarvelLogo"))
        }
        
    }
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.5
        
    }
    
    
    
}
