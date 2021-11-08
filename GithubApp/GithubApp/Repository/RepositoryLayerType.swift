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
}