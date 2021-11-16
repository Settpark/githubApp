//
//  AuthenticationManagerType.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/16.
//

import Foundation
import RxSwift

protocol AuthenticationManagerType {
    var result: PublishSubject<String> { get }
    func startWebAuthSession(in window: UIWindow, query: QueryItems)
}
