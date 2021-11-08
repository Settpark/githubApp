//
//  LoginViewModel.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/08.
//

import Foundation

class LoginViewModel {
    
    private let repository: RepositoryLayer
    
    init(repositoryLayer: RepositoryLayer) {
        self.repository = repositoryLayer
    }
}
