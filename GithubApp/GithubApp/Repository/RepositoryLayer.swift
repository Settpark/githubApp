//
//  Repository.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/05.
//

import Foundation
import RxSwift

final class RepositoryLayer: RepositoryLayerType {
    private let apiService: APIServiceType
    
    init(apiService: APIServiceType) {
        self.apiService = apiService
    }
    
    func requestRepositoryList(path: Paths, query: String) -> Observable<SearchResult> {
        return apiService.requestData(type: SearchResult.self, path: path, query: query)
    }
    
    func requestAccessToken(path: Paths, query: String) -> Observable<AccessTokenModel> {
        return apiService.requestAccessToken(type: AccessTokenModel.self, path: path, query: query)
    }
}
