//
//  LoginViewModel.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/08.
//

import Foundation
import RxCocoa
import RxSwift

class LoginViewModel {
    
    private let repository: RepositoryLayerType
    private let disposeBag: DisposeBag
    let outputUserinfo: PublishSubject<UserModelDTO>
    let inputToken: PublishSubject<AccessTokenModel>
    let outputUserRepo: PublishSubject<[RepositoryListSectionData]>
    var userToken: AccessTokenModel?
    
    init(repositoryLayer: RepositoryLayerType) {
        self.repository = repositoryLayer
        self.disposeBag = DisposeBag()
        self.outputUserinfo = PublishSubject<UserModelDTO>()
        self.inputToken = PublishSubject<AccessTokenModel>()
        self.outputUserRepo = PublishSubject<[RepositoryListSectionData]>()
        self.userToken = nil

        self.inputToken
            .flatMap { token -> Observable<UserModelDTO> in
                self.userToken = token
                let token = URLQueryItem.init(name: "token", value: token.accessToken)
                return self.requestUserData(path: .user, token: [token])
            }.bind(to: outputUserinfo)
            .disposed(by: self.disposeBag)
        
        self.inputToken
            .flatMap { token -> Observable<[RepositoryListSectionData]> in
                self.userToken = token
                let token = URLQueryItem.init(name: "token", value: token.accessToken)
                return self.requestUserRepos(path: .userRepo, token: [token])
            }.bind(to: outputUserRepo)
            .disposed(by: self.disposeBag)
    }
    
    func getAceessToken(path: Paths, query: [URLQueryItem]) -> Observable<AccessTokenModel> {
        return repository.requestAccessToken(path: path, query: query)
    }
    
    func requestUserData(path: Paths, token: [URLQueryItem]) -> Observable<UserModelDTO> {
        return repository.requestUserData(type: UserModelDTO.self, path: path, token: token)
    }
    
    func requestUserRepos(path: Paths, token: [URLQueryItem]) -> Observable<[RepositoryListSectionData]> {
        return repository.requestUserData(type: [RepositoriesModel].self, path: path, token: token)
            .map { data in
                let temp = [RepositoryListSectionData.init(items: data)]
                return temp
            }
    }
    
    func checkStaredUserRepo(path: Paths, query: [URLQueryItem], method: HttpMethod) -> Observable<Bool> {
        guard let accessToken = userToken?.accessToken else {
            return Observable<Bool>.just(false)
        }
        let tempToken = URLQueryItem(name: "token", value: accessToken)
        var tempQuery = query
        tempQuery.append(tempToken)
        
        return repository.starUserrepo(path: path, query: tempQuery, method: method)
            .map { statuscode -> Bool in
                if statuscode > 400 { return false }
                else { return true }
            }
    }
    
    func starUserRepo(path: Paths, query: [URLQueryItem], method: HttpMethod) {
        guard let accessToken = userToken?.accessToken else {
            return
        }
        let tempToken = URLQueryItem(name: "token", value: accessToken)
        var tempQuery = query
        tempQuery.append(tempToken)
        
        repository.starUserrepo(path: path, query: tempQuery, method: method)
            .subscribe{ _ in }
            .disposed(by: self.disposeBag)
    }
    
    func requestUserimage(url: String) -> Observable<Data> {
        return repository.requestUserimage(url: url)
    }
}
