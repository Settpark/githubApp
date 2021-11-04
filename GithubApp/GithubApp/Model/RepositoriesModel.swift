//
//  Repositories.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/04.
//

import Foundation

struct RepositoriesModel: Decodable {
    let name: String
    let owner: Owner
    let description: String
    let stargazerCount: Int
    let topics: [String]?
}
