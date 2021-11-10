//
//  StarButtonDelegate.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/10.
//

import RxSwift
import UIKit

protocol StarButtonDelegate: AnyObject {    
    func starRepository(owner: String, repo: String)
}
