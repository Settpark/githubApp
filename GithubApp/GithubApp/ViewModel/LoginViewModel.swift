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
    
    init(repositoryLayer: RepositoryLayerType) {
        self.repository = repositoryLayer
        self.disposeBag = DisposeBag()
        self.outputUserinfo = PublishSubject<UserModelDTO>()
        self.inputToken = PublishSubject<AccessTokenModel>()
        self.outputUserRepo = PublishSubject<[RepositoryListSectionData]>()

        self.inputToken
            .flatMap { token in
                return self.requestUserData(path: .user, token: token.accessToken ?? "")
            }.bind(to: outputUserinfo)
            .disposed(by: self.disposeBag)
        
        self.inputToken
            .flatMap { token in
                return self.requestUserRepos(path: .userRepo, token: token.accessToken ?? "")
            }.bind(to: outputUserRepo)
            .disposed(by: self.disposeBag)
    }
    
    func getAceessToken(path: Paths, query: String) -> Observable<AccessTokenModel> {
        return repository.requestAccessToken(path: path, query: query)
    }
    
    func requestUserData(path: Paths, token: String) -> Observable<UserModelDTO> {
        return repository.requestUserData(type: UserModelDTO.self, path: path, token: token)
    }
    
    func requestUserRepos(path: Paths, token: String) -> Observable<[RepositoryListSectionData]> {
        return repository.requestUserData(type: [RepositoriesModel].self, path: path, token: token)
            .map { data in
                let temp = [RepositoryListSectionData.init(items: data)]
                return temp
            }
    }
    
    func requestUserimage(url: String) -> Observable<Data> {
        return repository.requestUserimage(url: url)
    }
}
