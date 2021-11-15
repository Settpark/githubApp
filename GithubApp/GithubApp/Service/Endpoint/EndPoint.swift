//
//  EndPoint.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/15.
//

import Foundation

struct EndPoint: EndPointManager {
    var scheme: String
    var host: String
    var path: String?
    
    init(host: Host, path: Paths?) {
        self.scheme = "https"
        self.host = host.rawValue
        self.path = path?.rawValue
    }
    
    func createValidURL(with query: QueryItems?) -> URL {
        var urlcomponents = URLComponents()
        urlcomponents.scheme = self.scheme
        urlcomponents.host = self.host
        if let validPath = self.path {
            urlcomponents.path = validPath
        }
        urlcomponents.queryItems = query?.getQueryitem()
        
        guard let validURL = urlcomponents.url else {
            return URL(string: "")!
        }
        
        return validURL
    }
    
    func createValidURLChange(path query: QueryItems) -> URL {
        var urlcomponets = URLComponents()
        urlcomponets.scheme = self.scheme
        urlcomponets.host = self.host
        // path가 있으면 path 바꾸지 말고 방출해야 함
        urlcomponets.path = query.createNew(path: self.path)
        
        guard let validURL = urlcomponets.url else {
            return URL(string: "")! //redirect를 줘야 하나?
        }
        
        return validURL
    }
}
