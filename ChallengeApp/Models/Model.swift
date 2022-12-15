//
//  Model.swift
//  ChallengeApp
//
//  Created by jekster on 13.12.2022.
//

import Foundation

struct Post: Codable {    
    var postId: Int
    var id: Int
    var name: String
    var email: String
    var body: String
}
