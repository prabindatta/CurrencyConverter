//
//  RequestHandler.swift
//  TemplateProject
//
//  Created by Benoit PASQUIER on 13/01/2018.
//  Copyright © 2018 Benoit PASQUIER. All rights reserved.
//

import Foundation

class RequestHandler {
    
    let reachability = Reachability()!
    
    func networkResult<T: Decodable>(completion: @escaping ((Result<T, ErrorResult>) -> Void)) -> 
        ((Result<Data, ErrorResult>) -> Void) {
            
            return { dataResult in 
                
                DispatchQueue.global(qos: .background).async(execute: { 
                    switch dataResult {
                    case .success(let data) : 
                        guard let newModel = try? JSONDecoder().decode(T.self, from: data) else {
                            completion(.failure(.parser(string: "Error while parsing json data")))
                            return
                        }
                        
                        completion(.success(newModel))
                    case .failure(let error) :
                        print("Network error \(error)")
                        completion(.failure(.network(string: "Network error " + error.localizedDescription)))
                    }
                })
                
            }
    }
}
