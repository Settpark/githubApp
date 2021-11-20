//
//  UserModel.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/09.
//

import Foundation

struct UserModelDTO: Decodable {
    let login: String
    let avatarUrl: String?
    
    static var empty = Self()
    
    init() {
        login = ""
        avatarUrl = ""
    }
}
