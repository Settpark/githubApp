//
//  APIServiceType.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/04.
//

import Foundation
import RxSwift

protocol APIServiceType {
    func requestData<T: Decodable>(type: T.Type, path: Paths, query: [URLQueryItem]) -> Observable<T>
    func requestAccessToken<T: Decodable>(type: T.Type, path: Paths, query: [URLQueryItem]) -> Observable<T>
    func requestUserData<T: Decodable>(type: T.Type, path: Paths, token: [URLQueryItem]) -> Observable<T>
    func starUserrepo(path: Paths, token: [URLQueryItem], method: HttpMethod) -> Observable<(response: HTTPURLResponse, data: Data)>
    func getfetchedImage(url: String) -> Observable<Data>
}
