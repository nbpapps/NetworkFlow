//
//  JsonParser.swift
//
//  Copyright © 2020 nbpApps. All rights reserved.
//

import Foundation

internal struct JsonParser {
    
    private var data : Data
    private var decoder : JSONDecoder
    
    init(data : Data,decoder : JSONDecoder = JSONDecoder()) {
        self.data = data
        self.decoder = decoder
    }
    
    func decode<T : Decodable>() -> Result<T,Error>{
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let decodedObject = try decoder.decode(T.self, from: data)
            return .success(decodedObject)
        }
        catch {
            return .failure(error)
        }
    }
}
