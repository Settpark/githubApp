//
//  RepositoryLayerProtocol.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/20.
//

import Foundation
import RxSwift
import RxRelay

class RepositoryDummy: RepositoryLayerType {
    func clearSearchResult() { }
    
    func startWebAuthSession(window: UIWindow, query: QueryItems) { }
    
    func isExistToken() -> BehaviorRelay<Bool> {
        return BehaviorRelay<Bool>(value: false)
    }
    
    func deleteToken() { }
    
    func requestUserData() -> Observable<UserModelDTO> {
        return Observable<UserModelDTO>.just(UserModelDTO.empty)
    }
    
    func requestUserRepo() -> Observable<[RepositoriesModel]> {
        let dummy: [RepositoriesModel] = []
        return Observable.just(dummy)
    }
    
    func requestUserimage(url: String?) -> Observable<Data> {
        return Observable.just(Data())
    }
    
    func requestStarRepo(httpMethod: HttpMethod, query: QueryItems) -> Observable<Int> {
        return Observable.just(200)
    }
    
    func requestRepositoryList(query: QueryItems) -> Observable<RepositoriesModelDTO> {
        let dummy = RepositoriesModelDTO(items: [])
        return Observable.just(dummy)
    }
}
