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
    @objc dynamic var name : String = ""
    @objc dynamic var resultDescription : String = ""
    @objc dynamic var modified : String = ""
    @objc dynamic var thumbnail : String = ""//thumbnail + extension
    @objc dynamic var resourceURI : String = ""
    
    let comics = List<ContainersRealm>()
    let series = List<ContainersRealm>()
    let events = List<ContainersRealm>()
    let stories = List<ContainersStoriesRealm>()
    let urls = List<URLElementRealm>()
    
}

class ContainersRealm : Object {
    @objc dynamic var available : Int = 0
    @objc dynamic var collectionURI : String = ""
    @objc dynamic var returned : Int = 0
    
    let items = List<containerItemRealm>()
    
}

class containerItemRealm : Object {
    @objc dynamic var resourceURI : String = ""
    @objc dynamic var name : String = ""
}

//===

class ContainersStoriesRealm : Object {
    @objc dynamic var available : Int = 0
    @objc dynamic var collectionURI : String = ""
    @objc dynamic var returned : Int = 0
    
    let items = List<containerStoriesRealm>()
}

class containerStoriesRealm : Object {
    @objc dynamic var resourceURI : String = ""
    @objc dynamic var name : String = ""
    @objc dynamic var type : String = ""
}

//===

class URLElementRealm : Object {
    @objc dynamic var type : String = ""
    @objc dynamic var url : String = ""
}





