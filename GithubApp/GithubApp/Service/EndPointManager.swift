//
//  EndPointManager.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/08.
//

import Foundation

protocol EndPointManager {
    var scheme: String { get }
    var host: EndPoints { get }
    
    init()
    
    func createValidURL(path: Paths, query: String?) -> URL
}
