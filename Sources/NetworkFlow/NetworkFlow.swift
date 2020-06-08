
//
//  NetworkDataFlow.swift
//
//  Copyright © 2020 nbpApps. All rights reserved.
//

import Foundation

public protocol EndpointURLProviding {
    var endpointURL : URL { get }
}

public protocol NetworkDataObtaining {
    public func getData<T:Decodable>(for endPointURLProvider : EndpointURLProviding, with completion :@escaping (Result<T,Error>) -> Void)
}

public class NetworkDataFlow : NetworkDataObtaining {
    
    init() {}
    
    //MARK: - This method is in charge of the flow - getting data from the network and parsing it into model data
    public func getData<T:Decodable>(for endPointURLProvider: EndpointURLProviding, with completion: @escaping (Result<T, Error>) -> Void) {
        fetchNetworkData(at: endPointURLProvider.endpointURL) {[weak self] (networkResult : Result<Data,Error>) in
            guard let self = self else {return}
            switch networkResult {
                
            case .success(let data):
                self.parseNetworkData(data: data) { (parserResult : Result<T,Error>) in
                    DispatchQueue.main.async {
                        switch parserResult {
                        case .success(let items):
                            completion(.success(items))
                        case .failure(let error):
                            completion(.failure(error)) // parser error
                        }
                    }
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error)) //network fail
                }
            }
        }
    }
    
    //MARK: - get the data form the network
    private func fetchNetworkData(at url : URL, with completion : @escaping (Result<Data,Error>) -> Void) {
        let networkAccess = NetworkAccess(url: url)
        networkAccess.fetchData() {(result) in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    //MARK: - parse the data
    private func parseNetworkData<T:Decodable>(data : Data,with completion : @escaping (Result<T,Error>) -> Void){
        let jsonParser = JsonParser(data: data)
        let result : Result<T,Error> = jsonParser.decode()
        completion(result)
    }
}




////
////  NetworkAccess.swift
////
////  Copyright © 2020 nbpApps. All rights reserved.
////
//
//import Foundation
//
//enum NetworkError : Error {
//    case networkError
//    case responseError
//    case InvalidData
//}
//
//typealias NetworkCompletion =  (Result<Data,NetworkError>) -> Void
//
//struct NetworkAccess {
//    
//    private var url : URL
//    private var session : URLSession
//    
//    init(url : URL,session : URLSession = URLSession.shared) {
//        self.url = url
//        self.session = session
//    }
//    
//    func fetchData(with completion : @escaping NetworkCompletion) {
//        let task = session.dataTask(with: url) { (data, response, error) in
//            
//            guard error == nil else {
//                completion(.failure(.networkError))
//                return
//            }
//
//            guard let networkResponse = response as? HTTPURLResponse, networkResponse.statusCode == 200 else {
//                completion(.failure(.responseError))
//                return
//            }
//            
//            guard let receivedData = data else {
//                completion(.failure(.InvalidData))
//                return
//            }
//            
//            completion(.success(receivedData))
//        }
//        task.resume()
//    }
//}
//
