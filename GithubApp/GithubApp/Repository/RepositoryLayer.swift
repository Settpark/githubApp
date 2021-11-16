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
    
    func clearSearchResult() {
        self.searchResultList.items.removeAll()
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
    
    func requestUserData() -> Observable<UserModelDTO> {
        let token = self.secureStorage.readToken()
        let endPoint = EndPoint.init(host: .api, path: .User)
        return self.apiService.requestUserData(endPoint: endPoint, type: UserModelDTO.self, token: token?.accessToken ?? "") // 옵셔널 처리 -> 빈 모델?
    }
    
    func requestUserRepo() -> Observable<[RepositoriesModel]> {
        let token = self.secureStorage.readToken()
        let endPoint = EndPoint.init(host: .api, path: .UserRepo)
        return self.apiService.requestUserData(endPoint: endPoint, type: [RepositoriesModel].self, token: token?.accessToken ?? "") //옵셔널 처리 -> 빈 배열?
    }
    
    func requestUserimage(url: String?) -> Observable<Data> {
        return apiService.getfetchedImage(url: url)
    }
    
    func requestStarRepo(httpMethod: HttpMethod, query: QueryItems) -> Observable<Int> {
        let token = self.secureStorage.readToken()
        return apiService.starUserrepo(httpMethod: httpMethod, query: query, token: token?.accessToken ?? "") // 옵셔널 처리 실패 statusCode?
            .map { return $0.response.statusCode }
    }
}
