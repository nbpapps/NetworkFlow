//
//  NetworkAccess.swift
//
//  Copyright © 2020 nbpApps. All rights reserved.
//

import Foundation

enum NetworkError : Error {
    case networkError
    case responseError
    case InvalidData
}

typealias NetworkCompletion =  (Result<Data,NetworkError>) -> Void

internal struct NetworkAccess {
    
    private var url : URL
    private var session : URLSession
    
    init(url : URL,session : URLSession = URLSession.shared) {
        self.url = url
        self.session = session
    }
    
    func fetchData(with completion : @escaping NetworkCompletion) {
        let task = session.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else {
                completion(.failure(.networkError))
                return
            }

            guard let networkResponse = response as? HTTPURLResponse, networkResponse.statusCode == 200 else {
                completion(.failure(.responseError))
                return
            }
            
            guard let receivedData = data else {
                completion(.failure(.InvalidData))
                return
            }
            
            completion(.success(receivedData))
        }
        task.resume()
    }
}

