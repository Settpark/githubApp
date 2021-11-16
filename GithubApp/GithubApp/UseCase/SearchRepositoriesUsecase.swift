//
//  SearchRepositoriesUsecase.swift.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/15.
//

import Foundation
import RxSwift

class SearchRepositoriesUsecase: CommonUsecase {
    
    func requestRepositories(value: String) -> Observable<[RepositoriesModel]> {
        self.repository.clearSearchResult()
        let query = QueryItems()
        query.addQuery(newKey: "q", newElement: value)
        query.addQuery(newKey: "per_page", newElement: "\(15)")
        return repository.requestRepositoryList(query: query)
            .map { return $0.items }
    }
    
    func requestNextRepositories(value: String, page: Int) -> Observable<[RepositoriesModel]> {
        let query = QueryItems()
        query.addQuery(newKey: "q", newElement: value)
        query.addQuery(newKey: "per_page", newElement: "\(15)")
        query.addQuery(newKey: "page", newElement: "\(page)")
        return repository.requestRepositoryList(query: query)
            .map { return $0.items }
    }
}
