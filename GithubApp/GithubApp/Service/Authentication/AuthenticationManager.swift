//
//  AuthenticationManager.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/16.
//

import Foundation
import AuthenticationServices
import RxSwift

class AuthenticationManager: NSObject, ASWebAuthenticationPresentationContextProviding, AuthenticationManagerType {
    
    private let callbackURL: String
    private var presentationWindow: UIWindow?
    var result: PublishSubject<String>
    
    override init() {
        self.callbackURL = "settgithubapp"
        self.result = PublishSubject<String>()
        super.init()
    }
    
    func startWebAuthSession(in window: UIWindow, query: QueryItems) {
        self.presentationWindow = window
        let endPoint = EndPoint.init(host: .loginAuthorization, path: .LoginPath)
        let url = endPoint.createValidURL(with: query)
        
        let webAuthSession = ASWebAuthenticationSession.init(url: url, callbackURLScheme: self.callbackURL) { [weak self] callBack, error in
            guard error == nil, let validCallback = callBack else {
                return
            }
            let code = validCallback.absoluteString.components(separatedBy: "code=").last ?? ""
            self?.result.onNext(code)
        }
        webAuthSession.presentationContextProvider = self
        webAuthSession.start()
    }
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.presentationWindow ?? UIWindow()
    }
}

