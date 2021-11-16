//
//  RepositoryType.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/05.
//

import Foundation
import RxSwift
import RxRelay

protocol RepositoryLayerType {
    func requestRepositoryList(query: QueryItems) -> Observable<RepositoriesModelDTO>
    func clearSearchResult()
    
    func startWebAuthSession(window: UIWindow, query: QueryItems)
    func isExistToken() -> BehaviorRelay<Bool>
    func deleteToken()
    
    func requestUserData() -> Observable<UserModelDTO>
    func requestUserRepo() -> Observable<[RepositoriesModel]>
    func requestUserimage(url: String?) -> Observable<Data>
    func requestStarRepo(httpMethod: HttpMethod, query: QueryItems) -> Observable<Int>
}
