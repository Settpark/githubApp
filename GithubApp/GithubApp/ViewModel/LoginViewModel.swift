//
//  LoginViewModel.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/08.
//

import Foundation
import RxSwift

class LoginViewModel {
    
    private let repository: RepositoryLayer
    
    init(repositoryLayer: RepositoryLayer) {
        self.repository = repositoryLayer
    }
    
    func getAceessToken(path: Paths, query: String) -> Observable<AccessTokenModel> {
        return repository.requestAccessToken(path: path, query: query)
    }
}
