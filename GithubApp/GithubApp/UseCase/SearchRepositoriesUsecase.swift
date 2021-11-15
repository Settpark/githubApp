//
//  SearchRepositoriesUsecase.swift.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/15.
//

import Foundation
import RxSwift

class SearchRepositoriesUsecase {
    
    private let repository: RepositoryLayer
    
    init(repositoryLayer: RepositoryLayer) {
        self.repository = repositoryLayer
    }
    
    func requestRepositories(value: String) -> Observable<[RepositoriesModel]> {
        let query = QueryItems()
        query.addQuery(newKey: "q", newElement: value)
        query.addQuery(newKey: "per_page", newElement: "\(30)")
        query.addQuery(newKey: "page", newElement: "0")
        return repository.requestRepositoryList(type: SearchResult.self, query: query)
            .map { return $0.items }
    }
}
