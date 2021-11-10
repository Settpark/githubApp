//
//  EndPointUserRepo.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/09.
//

import Foundation

struct EndPointUserRepo: EndPointManager {
    var scheme: String
    var host: EndPoints
    
    init() {
        self.scheme = "https"
        self.host = .api
    }
    
    func createValidURL(path: Paths, query: [URLQueryItem]) -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = self.scheme
        urlComponents.host = self.host.rawValue
        urlComponents.path = path.rawValue
        
        return urlComponents.url!
    }
}
