//
//  LoginUsecase.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/16.
//

import Foundation
import RxSwift
import RxRelay

class LoginUsecase: CommonUsecase {
    
    func isExistTokeninStorage() -> BehaviorRelay<Bool> {
        return self.repository.isExistToken()
    }
    
    func startWebAuthSession(in window: UIWindow) {
        let query = SecureQueryManager().createClientCode()
        self.repository.startWebAuthSession(window: window, query: query)
    }
    
    func deleteUserToken() {
        self.repository.deleteToken()
    }
}
