//
//  AlertControllerDelegate.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/25.
//

import UIKit

protocol AlertControllerDelegate: AnyObject {
    func showAlertController(message: AlertMessage)
}

enum AlertMessage: String {
    case emptyList = "리스트가 비어있습니다."
    case emptySearchBar = "검색하고자 하는 값이 비어있습니다."
}
