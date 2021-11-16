//
//  StarButtonDelegate.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/10.
//

import RxSwift

protocol StarDelegate: AnyObject {
    func starRepository(owner: String, repo: String) -> Observable<Void>
    func unstarRepository(owner: String, repo: String) -> Observable<Void>
    func checkStarRepository(owner: String, repo: String) -> Observable<Bool>
}
