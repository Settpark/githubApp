//
//  APIServiceType.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/04.
//

import Foundation
import RxSwift

protocol APIServiceType {
    func requestData<T: Decodable>(type: T.Type, path: Paths, query: String) -> Observable<T>
}
