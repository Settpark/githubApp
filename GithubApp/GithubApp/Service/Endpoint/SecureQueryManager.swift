//
//  SecureQueryManager.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/16.
//

import Foundation

final class SecureQueryManager: QueryItems {
    
    private let client_ID: String
    private let scope: String
    private let securityCode: String = "e99957ab54e97a6221fd0140860ed016ced004d9"
    
    override init() {
        client_ID = "e2bd49c6a5e231743253"
        scope = "repo user"
        super.init()
    }
    
    func createClientCode() -> QueryItems {
        let clientID = URLQueryItem(name: "client_id", value: self.client_ID)
        let scope = URLQueryItem(name: "scope", value: self.scope)
        let queries: [URLQueryItem] = [clientID, scope]
        let queryItems = QueryItems.init(queryItems: queries)
        return queryItems
    }
    
    func createAccessTokenQuery(code: String?) -> QueryItems { //에러 처리..
        let clientID = URLQueryItem(name: "client_id", value: self.client_ID)
        let securityCode = URLQueryItem(name: "client_secret", value: self.securityCode)
        var queries: [URLQueryItem] = [clientID, securityCode]
        if let validCode = code {
            let createdCode = URLQueryItem(name: "code", value: validCode)
            queries.append(createdCode)
        }
        return QueryItems.init(queryItems: queries)
    }
}
