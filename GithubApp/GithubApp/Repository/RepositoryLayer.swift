//
//  Repository.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/05.
//

import Foundation
import RxSwift
import RxCocoa

final class RepositoryLayer: RepositoryLayerType {
    private let apiService: APIServiceType
    private var repoListsRepository: [RepositoriesModel]
    
    init(apiService: APIServiceType) {
        self.apiService = apiService
        self.repoListsRepository = []
    }
    
    func requestRepositoryList<T: Decodable>(type: T.Type, query: QueryItems) -> Observable<T> {
        return apiService.requestRepositories(type: type, query: query)
            .do { print($0) }
//            .map { [weak self] searchresult in
//                searchresult.items.forEach { self?.repoListsRepository.append($0) }
//                return self?.repoListsRepository ?? []
//            }
    }
    
    func starUserrepo(path: Paths, query: [URLQueryItem], method: HttpMethod) -> Observable<Int> {
        Observable.just(1)
//        return apiService.starUserrepo(path: path, token: <#T##QueryItems#>)
//            .map { return $0.response.statusCode }
    }
    
    func requestAccessToken(path: Paths, query: [URLQueryItem]) -> Observable<AccessTokenModel> {
        Observable.just(AccessTokenModel())
//        return apiService.requestAccessToken(type: AccessTokenModel.self, path: path, query: query)
    }
    
    func requestUserData<T: Decodable>(type: T.Type, path: Paths, token: [URLQueryItem]) -> Observable<T> {
        Observable.just("" as! T)
//        return apiService.requestUserData(type: type.self, path: path, token: token)
    }
    
    func requestUserimage(url: String) -> Observable<Data> {
        return apiService.getfetchedImage(url: url)
    }
    
    func clearRepositories() {
        self.repoListsRepository.removeAll()
    }
}
