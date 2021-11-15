//
//  APIServiceType.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/04.
//

import Foundation
import RxSwift

protocol APIServiceType {
    func requestDataWithRx<T: Decodable>(type: T.Type, with request: URLRequest) -> Observable<T>
    func requestRepositories<T: Decodable>(type: T.Type, query: QueryItems) -> Observable<T>
    func requestAccessToken<T: Decodable>(type: T.Type, query: QueryItems) -> Observable<T>
    func requestUserData<T: Decodable>(type: T.Type, token: QueryItems) -> Observable<T>
    func starUserrepo(path: Paths, token: QueryItems) -> Observable<(response: HTTPURLResponse, data: Data)>
    func getfetchedImage(url: String) -> Observable<Data>
}
