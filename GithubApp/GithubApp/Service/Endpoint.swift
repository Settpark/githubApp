//
//  Endpoint.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/04.
//

import Foundation

struct EndPoint {
    private let scheme: String
    private let host: String
    
    init() {
        self.scheme = "https"
        self.host = "api.github.com"
    }
    
    func createValidURL(path: Paths, query: String) -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = self.scheme
        urlComponents.host = self.host
        urlComponents.path = path.rawValue
        urlComponents.query = "q=" + query
        
        guard let url = urlComponents.url else {
            fatalError("The Requested URL Cannot be Found")
        }
        
        return url
    }
}
