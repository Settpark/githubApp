//
//  EndPointManager.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/08.
//

import Foundation

protocol EndPointManager {
    var scheme: String { get }
    var host: String { get }
    var path: String? { get }
    
    init(host: Host, path: Paths?)
    
    func createValidURL(with query: QueryItems?) -> URL
}

