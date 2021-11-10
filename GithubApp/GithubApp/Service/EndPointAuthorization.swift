//
//  LoginManager.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/08.
//

import Foundation

struct EndPointAuthorization: EndPointManager {
    
    var scheme: String
    var host: EndPoints
    
    init() {
        self.scheme = "https"
        self.host = EndPoints.loginAuthorization
    }
    
    func createValidURL(path: Paths, query: [URLQueryItem]) -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = self.scheme
        urlComponents.host = self.host.rawValue
        urlComponents.path = path.rawValue
        
        let clientID = Client.clientID
        let scope = "repo user"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: clientID.rawValue),
            URLQueryItem(name: "scope", value: scope),
        ]
        return urlComponents.url!
    }
}
