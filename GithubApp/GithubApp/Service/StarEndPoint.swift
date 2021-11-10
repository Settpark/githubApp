//
//  StarEndPoint.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/10.
//

import Foundation

struct StarEndPoint: EndPointManager {
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
        if let name = query.first?.value, let repo = query[1].value {
            let newPath = path.rawValue + "/" + name + "/" + repo
            urlComponents.path = newPath
        }
        return urlComponents.url!
    }
}
