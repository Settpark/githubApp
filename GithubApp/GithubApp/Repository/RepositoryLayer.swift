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
    
    func requestRepositoryList(path: Paths, query: [URLQueryItem]) -> Observable<SearchResult> {
        return apiService.requestData(type: SearchResult.self, path: path, query: query)
    }
    
    func requestAccessToken(path: Paths, query: [URLQueryItem]) -> Observable<AccessTokenModel> {
        return apiService.requestAccessToken(type: AccessTokenModel.self, path: path, query: query)
    }
    
    func requestUserData<T: Decodable>(type: T.Type, path: Paths, token: [URLQueryItem]) -> Observable<T> {
        return apiService.requestUserData(type: type.self, path: path, token: token)
    }
    
    func requestUserimage(url: String) -> Observable<Data> {
        return apiService.getfetchedImage(url: url)
    }
}
