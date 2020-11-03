//
//  CustomCollectionViewCell.swift
//  MarvelApp
//
//  Created by Alan Silva on 21/02/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import UIKit
import SDWebImage
import RealmSwift

protocol CustomCollectionViewCellDelegate : class {
    func setCharacterAsFavorite()
}

class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var favoriteView: UIView!
    @IBOutlet weak var starCutton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let realm = try! Realm()
    
    static let cell = "CustomCollectionViewCell"
    
    weak var delegate : CustomCollectionViewCellDelegate?
    
    var characterProfile : CharactersElementRealm! {
        
        didSet {
            
            self.activityIndicator.startAnimating()
            
            self.myLabel.text = characterProfile.name
            self.myImageView.sd_setImage(with: URL(string: ("\(characterProfile.thumbnail)")), placeholderImage: UIImage(named: "MarvelLogo"), options: .continueInBackground) { (image, error, cache, url) in
                
                self.activityIndicator.stopAnimating()
                
            }
            //self.myImageView.sd_setImage(with: URL(string: ("\(characterProfile.thumbnail)")), placeholderImage: UIImage(named: "MarvelLogo"))
            let systemName = characterProfile.favorite ? "star.fill" : "star"
            self.starCutton.setImage(UIImage(systemName: systemName), for: .normal)
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.5
        
        favoriteView.layer.borderColor = UIColor.black.cgColor
        favoriteView.layer.borderWidth = 0.5
        
    }
    
    @IBAction func btnFavorite(_ sender: UIButton) {
        
        sender.pulse()
        
        if let item = self.characterProfile {
            
            let icon = item.favorite ? "Desfavoritado" : "Favoritado"
            print("====Favorite Status Changed on Realm ====")
            print("\(item.name)#\(icon)")
            
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
        
        self.delegate?.setCharacterAsFavorite()
        
    }
    
    private func setStarStatus(){
        
        if let item = self.characterProfile {
            if item.favorite {
                
                self.starCutton.setImage(UIImage(systemName: "star.fill"), for: .normal)
                
            }
            else{
                
                self.starCutton.setImage(UIImage(systemName: "star"), for: .normal)
                
            }
            
        }
        
    }
    
}
