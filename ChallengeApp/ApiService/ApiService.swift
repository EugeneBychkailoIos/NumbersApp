//
//  ApiService.swift
//  ChallengeApp
//
//  Created by jekster on 13.12.2022.
//

import Foundation

protocol ApiServiceProtocol {
    func request(request: URLRequest, handler: @escaping (ApiService.Result) -> Void)
    
}

class ApiService {
    
    public enum Result {
        case success(Data)
        case fail(Error)
    }
}

extension ApiService: ApiServiceProtocol {
    func request(request: URLRequest, handler: @escaping (ApiService.Result)-> Void) {
        let task = URLSession.shared.dataTask(with: request) { (data, _, Error) in
            if let Error = Error {
                handler(Result.fail(Error))
                return
            }
            if let data = data {
                handler(Result.success(data))
                return
            }
        }
        task.resume()
    }
}
