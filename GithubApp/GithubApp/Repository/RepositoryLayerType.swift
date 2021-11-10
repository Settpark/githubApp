//
//  RepositoryType.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/05.
//

import Foundation
import RxSwift

protocol RepositoryLayerType {
    func requestRepositoryList(path: Paths, query: [URLQueryItem]) -> Observable<[RepositoriesModel]>
    func requestAccessToken(path: Paths, query: [URLQueryItem]) -> Observable<AccessTokenModel>
    func requestUserData<T: Decodable>(type: T.Type, path: Paths, token: [URLQueryItem]) -> Observable<T>
    func requestUserimage(url: String) -> Observable<Data>
    func starUserrepo(path: Paths, query: [URLQueryItem], method: HttpMethod) -> Observable<Int>
    func clearRepositories()
}
