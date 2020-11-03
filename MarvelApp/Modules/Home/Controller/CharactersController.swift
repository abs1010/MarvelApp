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
    func successOnFethingCharactersOfPageOffet()
    func errorOnFethingCharacters(error: Error)
    func limitOfRequestsHasBeenReached()
}

class CharactersController {
    
    var charactersArray : Results<CharactersElementRealm>?
    var favoriteCharactersArray : Results<CharactersElementRealm>?
    
    let realm = try! Realm()
    
    private var contador : Int = 0
    private var selectedIndex: Int = 0
    private var selectedFavoriteIndex: Int = 0
    private var maximumRequestAllowed = 0
    
    private var provider: DataProvider?
    
    weak var delegate : CharactersControllerDelegate?
    
    func checkLastOffSet(){
        
        if let lastOffset : Int = Utils.getObject(key: "lastOffset") as? Int {
            self.contador = lastOffset
        }
        
    }
    
    func setupController(){
        
        checkLastOffSet()
        
        self.provider = DataProvider(offset: contador)
        
        self.loadNewPageOfCharacters()
        
    }
    
    func loadUpCharacters(){
        
        self.charactersArray = realm.objects(CharactersElementRealm.self)
        
    }
    
    func getNumberOfRows() -> Int{
        
        return charactersArray?.count ?? 0
        
    }
    
    func getCharacterWithIndexPath(_ index: IndexPath) -> CharactersElementRealm {
        
        guard let chaElement = self.charactersArray else { fatalError("No data available") }
        
        return chaElement[index.row]
        
    }
    
    func saveIndexSelected(index: Int) {
        
        self.selectedIndex = index
        
    }
    
    func getSelectedIndex() -> Int {
        return self.selectedIndex
    }
    
    func getCharacterWithIndexPathFromItem() -> CharactersElementRealm {
        
        return (self.charactersArray?[self.selectedIndex])!
        
    }
    
    func requestAnotherPage(){
        
        let offset = contador
        let nRequested = offset / 20
        let maxPermitted = self.maximumRequestAllowed / 20
        
        if maxPermitted + 1 <= nRequested {
            
            self.delegate?.limitOfRequestsHasBeenReached()

        }
        else {
            self.provider = DataProvider(offset: contador)
            self.loadNewPageOfCharacters()
            
            Utils.saveObject(key: "lastOffset", value: contador + 20)
            
        }
        
    }
    
    //MARK: - METHOD THAT REQUEST A NEW PAGE
    
    private func loadNewPageOfCharacters(){
        
        self.provider?.getCharactersPerPage(completion: { [weak self] (results) in
            
            switch results {
                
            case .success(let dataClassOk):
                print("===Success on fetching data for offset: \(dataClassOk.offset)===")
                
                DispatchQueue.main.async {
                    self?.contador += 20
                    self?.saveCharactersLocally(dataClassOk)
                    self?.loadUpCharacters()
                    self?.delegate?.successOnFethingCharactersOfPageOffet()
                    self?.maximumRequestAllowed = dataClassOk.total
                }
                
            case .failure(let resultFail):
                DispatchQueue.main.async {
                    self?.loadUpCharacters()
                    
                    if self?.getNumberOfRows() == 0 {
                        
                        print("===NO LOCAL DATA FOUND===")
                        self?.delegate?.errorOnFethingCharacters(error: resultFail)
                        
                    }
                    else{
                        
                        self?.delegate?.successOnFethingCharactersOfPageOffet()
                        
                    }
                    
                }
                
            }
            
        })
        
    }
    
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
                //container.type = (object?.type).map { $0.rawValue } ?? ""
                container.type = object?.type ?? ""
                
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
            
        }//ends for
        
    }
    
    //MARK:- CHECK IF OBJECT IS FAVORITE YET
    
    func isFavorite(id: Int) -> Bool {
        
        let check = realm.objects(CharactersElementRealm.self).filter("id = \(id)")
        if check.count != 0 {
            return true
        }
        
        return false
        
    }
    
    //MARK:- REMOVE ALL DATA FROM REALM MAIN
    
    static func removellAllDataFromRealm(){
        
        let realm = try! Realm()
        
        let allObjects = realm.objects(CharactersElementRealm.self)
        try! realm.write {
            realm.delete(allObjects)
        }
        
        let allObjects1 = realm.objects(containerItemRealm.self)
        try! realm.write {
            realm.delete(allObjects1)
        }
        
        let allObjects2 = realm.objects(storiesContainerItemRealm.self)
        try! realm.write {
            realm.delete(allObjects2)
        }
        
        print("===all data from realm has been removed===")
        
    }
    
    //MARK: - METHODS OF FAVORITESVIEWCONTROLLER
    
    func loadUpFavorites(){
        
        self.favoriteCharactersArray = realm.objects(CharactersElementRealm.self)
        self.favoriteCharactersArray = favoriteCharactersArray?.filter("favorite == true").sorted(byKeyPath: "name", ascending: true)
        
    }
    
    func getNumberOfFavorites() -> Int{
        
        return self.favoriteCharactersArray?.count ?? 0
        
    }
    
    func getCharacterWithIndexPathOfFavorites(_ index: IndexPath) -> CharactersElementRealm {
        
        guard let chaElement = self.favoriteCharactersArray else { fatalError("No data available") }
        
        return chaElement[index.row]
        
    }
    
    func saveIndexForSelectedFavorite(index: Int) {
        
        self.selectedFavoriteIndex = index
        
    }
    
    func getSelectedIndexForFavorite() -> Int {
        return self.selectedFavoriteIndex
    }
    
    func getCharacterWithIndexPathForFavorite() -> CharactersElementRealm {
        
        return (self.favoriteCharactersArray?[self.selectedFavoriteIndex])!
        
    }
    
}
