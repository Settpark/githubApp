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
    
    private let disposeBag: DisposeBag
    private let apiService: APIServiceType
    private let authentication: AuthenticationManagerType
    private let secureStorage: SecureStorage
    
    private var searchResultList: RepositoriesModelDTO
    private var loginState: BehaviorRelay<Bool>
    
    init(apiService: APIServiceType, authentication: AuthenticationManagerType, secureStorage: SecureStorage) {
        self.disposeBag = DisposeBag()
        self.apiService = apiService
        self.authentication = authentication
        self.secureStorage = secureStorage
        self.searchResultList = RepositoriesModelDTO(items: [])
        self.loginState = BehaviorRelay<Bool>(value: self.secureStorage.isExistToken())
        self.saveUserToken()
    }
    
    func requestRepositoryList(query: QueryItems) -> Observable<RepositoriesModelDTO> {
        return apiService.requestRepositories(type: RepositoriesModelDTO.self, query: query)
            .do(onNext: { [weak self] DTO in
                self?.searchResultList.additems(items: DTO.items)
            }).map { [weak self] data in
                return self?.searchResultList ?? data
            }
    }
    
    func startWebAuthSession(window: UIWindow, query: QueryItems) {
        self.authentication.startWebAuthSession(in: window, query: query)
    }
    
    func isExistToken() -> BehaviorRelay<Bool> {
        return self.loginState
    }
    
    func deleteToken() {
        self.secureStorage.deleteToken()
        self.loginState.accept(self.secureStorage.isExistToken())
    }
    
    private func saveUserToken() {
        authentication.result
            .flatMap { [weak self] code -> Observable<AccessTokenModel> in
                let query = SecureQueryManager().createAccessTokenQuery(code: code)
                return self?.apiService.requestAccessToken(type: AccessTokenModel.self, query: query) ?? Observable<AccessTokenModel>.just(AccessTokenModel.empty)
            }.subscribe { [weak self] token in
                self?.secureStorage.createToken(token)
                guard let isTokenIn = self?.secureStorage.isExistToken() else { return }
                self?.loginState.accept(isTokenIn)
            } onError: { error in
                //
            }.disposed(by: self.disposeBag)
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
