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
    
    var charactersArray : Results<CharactersElementRealm>?
    
    let realm = try! Realm()
    
    private var provider: DataProvider?
    
    weak var delegate : CharactersControllerDelegate?
    
    func setupController(offSet: Int){
        
        self.provider = DataProvider(offset: offSet)
        self.loadNewPageOfCharacters()
    }
    
    private func loadUpCharacters(){
        
        self.charactersArray = realm.objects(CharactersElementRealm.self)
        
        //reloadData() da tableView
        
    }
    
    //
    
    func getNumberOfRows() -> Int{
        
        return charactersArray?.count ?? 0
        
    }
    
    func getCharacterWithIndexPath(_index: IndexPath) -> CharactersElementRealm {
        
        return (self.charactersArray?[_index.row])!
        //Treat force unwrap later
        
    }
    
    //
    
    private func loadNewPageOfCharacters(){
        
        self.provider?.getCharactersPerPage(completion: { [weak self] (results) in
            
            switch results {
                
            case .success(let dataClassOk):
                print("===Success on fetching data for offset: \(dataClassOk.offset)===")
                print("\(dataClassOk.results.count) results")
                
                DispatchQueue.main.async {
                    self?.saveCharactersLocally(dataClassOk)
                    self?.loadUpCharacters()
                    self?.delegate?.successOnFethingCharactersOfPageOffet(offset: 80)
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
            
            let path = result.thumbnail?.path ?? ""
            if let thumbnailExtension = result.thumbnail?.thumbnailExtension {
                charactersElementRealm.thumbnail = "\(path).\(String(describing: thumbnailExtension))"
            }
            
            charactersElementRealm.resourceURI = result.resourceURI ?? ""
            
            //comics
            charactersElementRealm.comicsAvailable = result.comics?.available ?? 0
            charactersElementRealm.comicsCollectionURI = result.comics?.collectionURI ?? ""
            charactersElementRealm.comicsReturned = result.comics?.returned ?? 0
            
            guard let countComics = result.comics?.items?.count else { return }
            
            var num = 0
            while countComics > num {
                
                let object = result.comics?.items?[num]
                let container = containerItemRealm()
                
                container.resourceURI = object?.resourceURI ?? ""
                container.name = object?.name ?? ""
                
                charactersElementRealm.comicsItems.append(container)
                
                num += 1
                
            }
            
            //series
            charactersElementRealm.seriesAvailable = result.series?.available ?? 0
            charactersElementRealm.seriesCollectionURI = result.series?.collectionURI ?? ""
            charactersElementRealm.seriesReturned = result.series?.returned ?? 0
            
            guard let countSeries = result.series?.items?.count else { return }
            
            var numSeries = 0
            while countSeries > numSeries {
                
                let object = result.series?.items?[numSeries]
                let container = containerItemRealm()
                
                container.resourceURI = object?.resourceURI ?? ""
                container.name = object?.name ?? ""
                
                charactersElementRealm.seriesItems.append(container)
                
                numSeries += 1
                
            }
            
            //stories
            charactersElementRealm.storiesAvailable = result.stories?.available ?? 0
            charactersElementRealm.storiesCollectionURI = result.stories?.collectionURI ?? ""
            charactersElementRealm.storiesReturned = result.stories?.returned ?? 0
            
            guard let countStories = result.stories?.items?.count else { return }
            
            var numStories = 0
            while countStories > numStories {
                
                let object = result.stories?.items?[numStories]
                let container = storiesContainerItemRealm()
                
                container.resourceURI = object?.resourceURI ?? ""
                container.name = object?.name ?? ""
                container.type = (object?.type).map { $0.rawValue } ?? ""
                
                charactersElementRealm.storieItems.append(container)
                
                numStories += 1
                
            }
            
            //events
            charactersElementRealm.eventsAvailable = result.events?.available ?? 0
            charactersElementRealm.eventsCollectionURI = result.events?.collectionURI ?? ""
            charactersElementRealm.eventsReturned = result.events?.returned ?? 0
            
            guard let countEvents = result.series?.items?.count else { return }
            
            var numEvents = 0
            while countEvents > numEvents {
                
                let object = result.series?.items?[numEvents]
                let container = containerItemRealm()
                
                container.resourceURI = object?.resourceURI ?? ""
                container.name = object?.name ?? ""
                
                charactersElementRealm.eventItems.append(container)
                
                numEvents += 1
                
            }
            
            //urls
            
            //SAVE ALL DATA
            do {
                
                try realm.write {
                    realm.add(charactersElementRealm)
                }
                
            }catch{
                
                print("Error saving context, \(error)")
                
            }
            
        }//for
        
    }
    
    static func removellAllDataFromRealm(){
        
        let realm = try! Realm()
        let allObjects = realm.objects(CharactersElementRealm.self)
        
        //DispatchQueue.main.async {
        
        try! realm.write {
            realm.delete(allObjects)
        }
        print("===all data from realm has been removed===")
        
    }
    
}
