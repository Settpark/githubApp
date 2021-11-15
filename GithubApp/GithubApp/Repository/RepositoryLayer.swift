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
    private var searchResultList: RepositoriesModelDTO
    
    init(apiService: APIServiceType) {
        self.apiService = apiService
        self.searchResultList = RepositoriesModelDTO(items: [])
    }
    
    func requestRepositoryList(query: QueryItems) -> Observable<RepositoriesModelDTO> {
        return apiService.requestRepositories(type: RepositoriesModelDTO.self, query: query)
            .do(onNext:  { [weak self] DTO in
                self?.searchResultList.additems(items: DTO.items)
            }).map { [weak self] data in
                return self?.searchResultList ?? data
            }
    }
    
    func clearSearchResult() {
        self.searchResultList.items.removeAll()
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
//        self.repoListsRepository.removeAll()
    }
}
