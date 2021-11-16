//
//  StarButtonDelegate.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/10.
//

import RxSwift
import RxCocoa

protocol LoginDelegate: AnyObject {
    func login(window: UIWindow?)
    func logout()
    func islogin() -> BehaviorRelay<Bool>
    func starRepository(owner: String, repo: String) -> Observable<Void>
    func unstarRepository(owner: String, repo: String) -> Observable<Void>
    func checkStarRepository(owner: String, repo: String) -> Observable<Bool>
}
