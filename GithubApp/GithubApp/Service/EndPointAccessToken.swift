//
//  EndPointAccessToken.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/08.
//

import Foundation

struct EndPointAccessToken: EndPointManager {
    
    var scheme: String
    var host: EndPoints
    
    init() {
        self.scheme = "https"
        self.host = .loginAuthorization
    }
    
    func createValidURL(path: Paths, query: String?) -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = self.scheme
        urlComponents.host = self.host.rawValue
        urlComponents.path = path.rawValue
        
        let clientID = Client.clientID
        let client_secret = Client.clientSecret
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: clientID.rawValue),
            URLQueryItem(name: "client_secret", value: client_secret.rawValue),
            URLQueryItem(name: "code", value: query),
        ]
        
        return urlComponents.url!
    }
}
