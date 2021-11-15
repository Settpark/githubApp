//
//  SearchResult.swift.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/05.
//

import Foundation

class RepositoriesModelDTO: Decodable {
    var items: [RepositoriesModel]
    
    init (items: [RepositoriesModel]) {
        self.items = items
    }
    
    func additems(items: [RepositoriesModel]) {
        items.forEach{ [weak self] model in
            self?.items.append(model)
        }
    }
}
