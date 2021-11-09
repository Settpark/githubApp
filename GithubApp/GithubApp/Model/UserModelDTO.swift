//
//  UserModel.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/09.
//

import Foundation

struct UserModelDTO: Decodable {
    var login: String
    var avatarUrl: String?
}
