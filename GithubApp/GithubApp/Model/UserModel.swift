//
//  UserModel.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/09.
//

import UIKit

struct UserModel {
    let login: String
    let avatar: UIImage?
    
    static let empty = Self()
    
    init() {
        login = ""
        avatar = UIImage()
    }
    
    init(login: String, avatarUrl: UIImage) {
        self.login = login
        self.avatar = avatarUrl
    }
}
