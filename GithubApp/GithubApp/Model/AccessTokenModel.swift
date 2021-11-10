//
//  AccessTokenModel.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/09.
//

import Foundation

struct AccessTokenModel: Decodable {
    let accessToken: String?
    let scope: String?
    let tokenType: String?
    
    init() {
        self.accessToken = nil
        self.scope = nil
        self.tokenType = nil
    }
}
