//
//  SearchResult.swift.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/05.
//

import Foundation

struct SearchResult: Decodable {
    let items: [RepositoriesModel]
}
