//
//  UsecaseProtocol.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/20.
//

import Foundation
import RxSwift

class UsecaseFakes: CommonUsecase {
    let query: QueryItems = QueryItems()
    
    func requestRepositories(value: String) -> Observable<[RepositoriesModel]> {
        query.addQuery(newKey: "q", newElement: value)
        query.addQuery(newKey: "per_page", newElement: "\(25)")
        return Observable.just([])
    }
}
