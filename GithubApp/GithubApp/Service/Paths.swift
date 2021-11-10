//
//  Pahts.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/04.
//

import Foundation

enum Paths: String {
    case Repositories = "/search/repositories"
    case LoginPath = "/login/oauth/authorize"
    case AccessToken = "/login/oauth/access_token"
    case user = "/user"
    case userRepo = "/user/repos"
    case star = "/user/starred"
}
