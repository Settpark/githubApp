//
//  LoginDelegate.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/10.
//

import RxSwift
import RxCocoa

protocol LoginDelegate: AnyObject {
    var isLogin: BehaviorRelay<Bool> { get }
    func Login() -> Void
}
