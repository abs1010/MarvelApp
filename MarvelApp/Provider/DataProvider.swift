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
    
    private let BASE_URL = ApiKeys.BASE_URL
    private let resourceURL:URL
    var limit = 20
    var offset = 0
    let API_KEY = ApiKeys.API_KEY
    let PRIVATE_KEY = ApiKeys.PRIVATE_KEY
    let ts = Date().currentTimeMillis()
    
    init(offset: Int) {
        
        let hashString = "\(ts)\(PRIVATE_KEY)\(API_KEY)".hashMD5()
        
        let resourceString = "\(BASE_URL)&offset=\(offset)&limit=\(limit)&apikey=\(API_KEY)&hash=\(hashString)&ts=\(ts)"
        
        guard let resourceURL = URL(string: resourceString) else {fatalError("Fail to convert the resource String")}
        
        self.resourceURL = resourceURL
        
    }
    
    //MARK: - GETTING THE DATA FROM SERVER
    func getCharactersPerPage(completion: @escaping(Result<DataClass, ResponseError>) -> Void) {
        
        URLSession.shared.dataTask(with: self.resourceURL) { data, _, _ in
            
            guard let jsonData = data else {
                print("===Error on fetching data (no data could be retrieved)===")
                completion(.failure(.noDataAvailable))
                return
            }
            
            do{
                let requestResults = try JSONDecoder().decode(MarvelHeader.self, from: jsonData)
                
                print("===Success on Parsing json data===")
                completion(.success(requestResults.data))
            }catch{
                print("===Error on parsing json data===")
                completion(.failure(.canNotProccessData))
            }
            
        }.resume()
        
    }
    
}
