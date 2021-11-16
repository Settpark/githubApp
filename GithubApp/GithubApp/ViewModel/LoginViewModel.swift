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
//    let outputUserinfo: PublishSubject<UserModelDTO>
    let outputUserRepo: PublishSubject<[RepositoryListSectionData]>
    
    init(usecase: LoginUsecase) {
        self.usecase = usecase
        self.disposeBag = DisposeBag()
//        self.outputUserinfo = PublishSubject<UserModelDTO>()
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
    
//    func requestUserData(path: Paths, token: [URLQueryItem]) -> Observable<UserModelDTO> {
//        return repository.requestUserData(type: UserModelDTO.self, path: path, token: token)
//    }
//
//    func requestUserRepos(path: Paths, token: [URLQueryItem]) -> Observable<[RepositoryListSectionData]> {
//        return repository.requestUserData(type: [RepositoriesModel].self, path: path, token: token)
//            .map { data in
//                let temp = [RepositoryListSectionData.init(items: data)]
//                return temp
//            }
//    }
//
//    func checkStaredUserRepo(path: Paths, query: [URLQueryItem], method: HttpMethod) -> Observable<Bool?> {
//        guard let accessToken = userToken?.accessToken else {
//            return Observable.just(nil)
//        }
//        let tempToken = URLQueryItem(name: "token", value: accessToken)
//        var tempQuery = query
//        tempQuery.append(tempToken)
//
//        return repository.starUserrepo(path: path, query: tempQuery, method: method)
//            .map { statuscode -> Bool in
//                if statuscode > 400 { return false }
//                else { return true }
//            }
//    }
    
//    func starUserRepo(path: Paths, query: [URLQueryItem], method: HttpMethod) {
//        guard let accessToken = userToken?.accessToken else {
//            return
//        }
//        let tempToken = URLQueryItem(name: "token", value: accessToken)
//        var tempQuery = query
//        tempQuery.append(tempToken)
//
//        repository.starUserrepo(path: path, query: tempQuery, method: method)
//            .subscribe{ _ in }
//            .disposed(by: self.disposeBag)
//    }
    
//    func requestUserimage(url: String) -> Observable<Data> {
//        return usecase.requestUserimage(url: url)
//    }
}
