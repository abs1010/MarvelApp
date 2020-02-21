//
//  ViewController.swift
//  MarvelApp
//
//  Created by Alan Silva on 17/02/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        
        teste(closure: { (result) in
            print(result.count)
        }, offSet: 20)
        
    }


    func teste(closure: @escaping(DataClass) -> Void, offSet: Int) {
        
        let provider = DataProvider(offset: offSet)
        
        provider.getCharactersPerPage { (result) in
            
            
            closure(result)
            
        }
        
        
    }

    
}

