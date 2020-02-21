//
//  File.swift
//  MarvelApp
//
//  Created by Alan Silva on 18/02/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import Foundation

enum ResponseError: Error{
    case noDataAvailable
    case canNotProccessData
}

struct DataProvider {
    
    private let BASE_URL = "https://gateway.marvel.com:443/v1/public/characters?"
    private let resourceURL:URL
    var limit = 20
    var offset = 0
    let API_KEY = "0ecb2efd9039475d8d69e0caa59022b9"//PUBLIC KEY
    let PRIVATE_KEY = "0913068b512e6a4dfb4460d69f95c507421c2ac8"
    let ts = Date().currentTimeMillis()
    
    init(offset: Int) {
        
        let hashString = "\(ts)\(PRIVATE_KEY)\(API_KEY)".hashMD5()
        
        let resourceString = "\(BASE_URL)&offset=\(offset)&limit=\(limit)&apikey=\(API_KEY)&hash=\(hashString)&ts=\(ts)"
        
        guard let resourceURL = URL(string: resourceString) else {fatalError("Fail to convert the resource String")}
        
        self.resourceURL = resourceURL
        
    }
    
    //MARK: - GETTING THE DATA FROM SERVER
    func getCharactersPerPage(completion: @escaping(DataClass) -> Void) {
        
        URLSession.shared.dataTask(with: self.resourceURL) { data, _, _ in
            
            guard let jsonData = data else {
                //set delegate for failure
                //completion(nil, ResponseError.noDataAvailable)
                return
            }
            
            do{
                let requestResults = try JSONDecoder().decode(MarvelHeader.self, from: jsonData)
                
                print(requestResults.data.results)
                completion(requestResults.data)
            }catch{
                //completion(ResponseError.canNotProccessData)
            }
            
        }.resume()
        
    }
    
}

extension DataProvider {
    
    enum Constants {
        
        static let BASE_URL = "https://gateway.marvel.com:443/v1/public/characters?"
        static let API_KEY = "0ecb2efd9039475d8d69e0caa59022b9"//PUBLIC KEY
        static let PRIVATE_KEY = "0913068b512e6a4dfb4460d69f95c507421c2ac8"
        
    }
    
}
