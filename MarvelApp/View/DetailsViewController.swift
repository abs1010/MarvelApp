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
    
    var selectedCharacter : CharactersElementRealm? {
     
        didSet{
            
            self.nameLabel.text = selectedCharacter?.name
            self.myImageView.sd_setImage(with: URL(string: ("\(selectedCharacter?.thumbnail)")), placeholderImage: UIImage(named: "MarvelLogo"))
            
        }
        
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var myImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        //self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

}
