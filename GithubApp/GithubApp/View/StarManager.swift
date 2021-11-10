//
//  StarButtonDelegate.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/10.
//

import RxSwift
import UIKit

protocol StarManager: AnyObject {    
    func starRepository(owner: String, repo: String)
    func unstarRespository(owner: String, repo: String)
    func checkStarRepository(owner: String, repo: String) -> Observable<Bool>
}
