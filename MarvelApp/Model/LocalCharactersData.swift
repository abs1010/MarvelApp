//
//  LocalCharactersData.swift
//  MarvelApp
//
//  Created by Alan Silva on 21/02/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import Foundation
import RealmSwift

class MarvelHeaderRealm : Object {
    
    @objc dynamic var code : Int = 0
    @objc dynamic var status : String = ""
    @objc dynamic var copyright : String = ""
    @objc dynamic var attributionText : String = ""
    @objc dynamic var attributionHTML : String = ""
    @objc dynamic var etag = ""
    
    let data = List<DataClassRealm>()
}

class DataClassRealm : Object {
    @objc dynamic var offset : Int = 0
    @objc dynamic var limit : Int = 0
    @objc dynamic var total : Int = 0
    @objc dynamic var count : Int = 0
    
    let results = List<CharactersElementRealm>()
}

class CharactersElementRealm : Object {
    @objc dynamic var id : Int = 0
    @objc dynamic var favorite : Bool = false
    @objc dynamic var name : String = ""
    @objc dynamic var resultDescription : String = ""
    @objc dynamic var modified : String = ""
    @objc dynamic var thumbnail : String = ""//thumbnail + extension
    @objc dynamic var resourceURI : String = ""
    
    @objc dynamic var comicsAvailable : Int = 0
    @objc dynamic var comicsCollectionURI : String = ""
    @objc dynamic var comicsReturned : Int = 0
    let comicsItems = List<containerItemRealm>()

    @objc dynamic var seriesAvailable : Int = 0
    @objc dynamic var seriesCollectionURI : String = ""
    @objc dynamic var seriesReturned : Int = 0
    let seriesItems = List<containerItemRealm>()

    @objc dynamic var eventsAvailable : Int = 0
    @objc dynamic var eventsCollectionURI : String = ""
    @objc dynamic var eventsReturned : Int = 0
    let eventItems = List<containerItemRealm>()

    @objc dynamic var storiesAvailable : Int = 0
    @objc dynamic var storiesCollectionURI : String = ""
    @objc dynamic var storiesReturned : Int = 0
    let storieItems = List<storiesContainerItemRealm>()
    
    let urls = List<URLElementRealm>()
    
}

class containerItemRealm : Object {
    @objc dynamic var resourceURI : String = ""
    @objc dynamic var name : String = ""
}


class storiesContainerItemRealm : Object {
    @objc dynamic var resourceURI : String = ""
    @objc dynamic var name : String = ""
    @objc dynamic var type : String = ""
}

//===

class URLElementRealm : Object {
    @objc dynamic var type : String = ""
    @objc dynamic var url : String = ""
}





