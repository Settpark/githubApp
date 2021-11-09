//
//  RepositoryType.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/05.
//

import Foundation
import RxSwift

protocol RepositoryLayerType {
    func requestRepositoryList(path: Paths, query: String) -> Observable<SearchResult>
    func requestAccessToken(path: Paths, query: String) -> Observable<AccessTokenModel>
    func requestUserData<T: Decodable>(type: T.Type, path: Paths, token: String) -> Observable<T>
    func requestUserimage(url: String) -> Observable<Data>
}
