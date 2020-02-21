//
//  CharactersController.swift
//  MarvelApp
//
//  Created by Alan Silva on 21/02/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import Foundation
import RealmSwift

protocol CharactersControllerDelegate : class {
    func successOnFethingCharactersOfPageOffet(offset: Int)
    func errorOnFethingCharacters(error: Error)
}

class CharactersController {
    
    var charactersArray : Results<DataClassRealm>?
    
    let realm = try! Realm()
    
    private var provider: DataProvider?
    
    private weak var delegate : CharactersControllerDelegate?
    
    func setupController(offSet: Int){
        
        self.provider = DataProvider(offset: offSet)
        self.loadNewPageOfCharacters()
    }
    
    private func loadNewPageOfCharacters(){
        
        self.provider?.getCharactersPerPage(completion: { [weak self] (results) in
            
            switch results {
                
            case .success(let dataClassOk):
                print("===Success on fetching data for offset: \(dataClassOk.offset)===")
                print("\(dataClassOk.results.count) results")
                
                DispatchQueue.main.async {
                    self?.saveCharactersLocally(dataClassOk)
                }
                
            case .failure(let resultFail):
                print(resultFail.localizedDescription)
            }
            
        })
        
    }
    
    //private func offsetCalculator(
    
    private func saveCharactersLocally(_ dataClass: DataClass) {
        
        //Sweeps the array of results [CharactersElement]
        for result in dataClass.results {
            
            let charactersElementRealm = CharactersElementRealm()
            
            charactersElementRealm.id = result.id ?? 0
            charactersElementRealm.name = result.name ?? ""
            charactersElementRealm.resultDescription = result.resultDescription ?? ""
            charactersElementRealm.modified = result.modified ?? ""
            //thumbnail
            charactersElementRealm.resourceURI = result.resourceURI ?? ""
            
            do {
                
                try realm.write {
                    realm.add(charactersElementRealm)
                }
                
            }catch{
                
                print("Error saving context, \(error)")
                
            }
            
        }//for
        
        //self.tableView.reloadData()
        
    }
    
    static func removellAllDataFromRealm(){
        
        let realm = try! Realm()
        let allObjects = realm.objects(CharactersElementRealm.self)
        
        //DispatchQueue.main.async {
            
            try! realm.write {
                realm.delete(allObjects)
            }
            print("===all data from realm has been removed===")
        //}
        
    }
    
}
