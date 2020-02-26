//
//  Utils.swift
//  MarvelApp
//
//  Created by Alan Silva on 26/02/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import Foundation

class Utils {
    
    static func saveStringObject(key: String, value: String){
        UserDefaults.standard.set(value, forKey: key)
    }
    
    static func getStringObject(key: String) -> String? {
        let value = UserDefaults.standard.string(forKey: key)
        return value
    }
    
    static func saveObject(key: String, value: Any) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    static func getObject(key: String) -> Any? {
        
        let value = UserDefaults.standard.object(forKey: key)
        
        return value
    }
    
    static func deleteObject(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
}
