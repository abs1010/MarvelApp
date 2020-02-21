//
//  Extensions.swift
//  MarvelApp
//
//  Created by Alan Silva on 20/02/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import Foundation
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

//MARK: - EXTENSION DATA PROVIDER API KEYS

extension DataProvider {
    
    enum ApiKeys {
        
        static let BASE_URL = "https://gateway.marvel.com:443/v1/public/characters?"
        static let API_KEY = "0ecb2efd9039475d8d69e0caa59022b9"//PUBLIC KEY
        static let PRIVATE_KEY = "0913068b512e6a4dfb4460d69f95c507421c2ac8"
        
    }
    
}

//MARK: - EXTENSION FOR HASH STRING
extension String {

    func hashMD5() -> String {

        let context = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: 1)
        var digest = Array<UInt8>(repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))

        CC_MD5_Init(context)
        CC_MD5_Update(context, self, CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8)))
        CC_MD5_Final(&digest, context)
        context.deallocate()

        var hexString = ""
        for byte in digest { hexString += String(format: "%02x", byte) }

        return hexString
    }
}

//MARK: - EXTENSION OF DATE TO GET TIMESTAMP

extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
