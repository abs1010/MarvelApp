//
//  MarvelAppTests.swift
//  MarvelAppTests
//
//  Created by Alan Silva on 17/02/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import XCTest
@testable import MarvelApp

class MarvelAppTests: XCTestCase {
    
    let controller = CharactersController()
    var sut : HomeViewController!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    func testCheckAPICall(){
        
        let dataProvider = DataProvider(offset: 0)
        
        let expec = expectation(description: "Running the callback closure in order to get Character data")
        
        dataProvider.getCharactersPerPage(completion: { (results) in
            
            XCTAssertNotNil(results)
            //XCTAssertNil(results)
            
            expec.fulfill()
            
        })
        
        waitForExpectations(timeout: 10, handler: { (error) in
            
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            
        })
        
        
    }
    
}
