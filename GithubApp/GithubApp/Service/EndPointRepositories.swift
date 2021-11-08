//
//  Endpoint.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/04.
//

import Foundation

struct EndPointRepositories: EndPointManager {
    var scheme: String
    var host: EndPoints
    
    init() {
        self.scheme = "https"
        self.host = EndPoints.api
    }
    
    func createValidURL(path: Paths, query: String?) -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = self.scheme
        urlComponents.host = self.host.rawValue
        urlComponents.path = path.rawValue
        urlComponents.query = "q=" + (query ?? "")
        
        guard let url = urlComponents.url else {
            fatalError("The Requested URL Cannot be Found")
        }
        
        return url
    }
}
