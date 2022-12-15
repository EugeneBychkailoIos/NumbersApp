//
//  Api.swift
//  ChallengeApp
//
//  Created by jekster on 13.12.2022.
//

import Foundation

protocol ApiImplementationProtocol {
    
    func getPosts(from: Int, to: Int) async throws -> [Post] 
}

class ApiImplementation {
    private let networkService: ApiServiceProtocol
    fileprivate let decoder = JSONDecoder()
    
    init (networkService: ApiServiceProtocol) {
        self.networkService = networkService
    }
    private let base = "https://jsonplaceholder.typicode.com/"
    
    var isCancelTask: Bool = false
}

extension ApiImplementation: ApiImplementationProtocol {
        
    func getPosts(from: Int, to: Int) async throws -> [Post]  {
        let range = from...to
        let allPosts = try await withThrowingTaskGroup(of: (Int, [Post]).self,
                                                       returning: [Int: [Post]].self,
                                                       body: { taskGroup in
            
            if isCancelTask {
            taskGroup.cancelAll()
            }
            
            for index in range {
                taskGroup.addTask {
                    guard let url = URL(string: self.base + "posts/\(index)/comments") else {
                        return ( 0, [Post(postId: 0, id: 0, name: "", email: "", body: "")] )
                    }
                    let (data, _) = try await URLSession.shared.data(from: url)
                    let posts = try JSONDecoder().decode([Post].self, from: data)
                    return (index, posts)
                }
            }
        
            var childTaskResults = [Int: [Post]]()
            for try await (key, value) in taskGroup {
                childTaskResults[key] = value
            }
            return childTaskResults
            
        })
        let indices = allPosts.keys.sorted()
        return indices.map{ allPosts[$0] ?? [Post(postId: 0, id: 0, name: "", email: "", body: "")] }.flatMap{$0}
    }
}

