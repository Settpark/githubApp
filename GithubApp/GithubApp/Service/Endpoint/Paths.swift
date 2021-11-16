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
    case AccessTokenPath = "/login/oauth/access_token"
    case User = "/user"
    case UserRepo = "/user/repos"
    case Star = "/user/starred"
}
