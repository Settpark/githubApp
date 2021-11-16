//
//  LoginViewModel.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/08.
//

import Foundation
import RxCocoa
import RxSwift

final class LoginViewModel {
    
    private let disposeBag: DisposeBag
    private let usecase: LoginUsecase
    let outputUserRepo: PublishSubject<[RepositoryListSectionData]>
    
    init(usecase: LoginUsecase) {
        self.usecase = usecase
        self.disposeBag = DisposeBag()
        self.outputUserRepo = PublishSubject<[RepositoryListSectionData]>()
    }
    
    func isLogin() -> BehaviorRelay<Bool> {
        return usecase.isExistTokeninStorage()
    }
    
    func logout() {
        self.usecase.deleteUserToken()
    }
    
    func login(in currentView: UIWindow) {
        self.usecase.startWebAuthSession(in: currentView)
    }
    
    func requestUserData() -> Observable<UserModel> {
        self.isLogin()
            .flatMap { [weak self] state -> Observable<UserModel> in
                if state {
                    return self?.usecase.requestUserData() ?? Observable.just(UserModel.empty)
                } else {
                    return Observable.just(UserModel.empty)
                }
            }
    }
    
    func requestUserRepo() -> Observable<[RepositoryListSectionData]> {
        self.isLogin()
            .flatMap { [weak self] state -> Observable<[RepositoriesModel]> in
                if state {
                    return self?.usecase.requestUserRepo() ?? Observable.just([])
                } else {
                    return Observable.just([])
                }
            }.map { data in
                let temp = [RepositoryListSectionData.init(items: data)]
                return temp
            }
    }
    
    func starRepo(owner: String, repo: String) -> Observable<Bool> {
        let query = QueryItems()
        query.addQuery(newKey: "owner", newElement: owner)
        query.addQuery(newKey: "repo", newElement: repo)
        return self.usecase.requestStarRepo(httpMethod: .put, query: query)
            .map { statusCode in
                if statusCode > 400 {
                    return false
                } else {
                    return true
                }
            }
    }
    
    func unstarRepo(owner: String, repo: String) -> Observable<Bool> {
        let query = QueryItems()
        query.addQuery(newKey: "owner", newElement: owner)
        query.addQuery(newKey: "repo", newElement: repo)
        return self.usecase.requestStarRepo(httpMethod: .delete, query: query)
            .map { statusCode in
                if statusCode > 400 {
                    return false
                } else {
                    return true
                }
            }
    }
    
    func isStarRepo(owner: String, repo: String) -> Observable<Bool> {
        let query = QueryItems()
        query.addQuery(newKey: "owner", newElement: owner)
        query.addQuery(newKey: "repo", newElement: repo)
        return self.usecase.requestStarRepo(httpMethod: .get, query: query)
            .map { statusCode in
                if statusCode > 400 {
                    return false
                } else {
                    return true
                }
            }
    }
}
