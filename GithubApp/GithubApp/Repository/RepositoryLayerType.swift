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
    
    func requestUserData<T: Decodable>(type: T.Type, path: Paths, token: [URLQueryItem]) -> Observable<T>
    func requestUserimage(url: String) -> Observable<Data>
    func starUserrepo(path: Paths, query: [URLQueryItem], method: HttpMethod) -> Observable<Int>
}
