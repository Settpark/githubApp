//
//  QueryItems.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/15.
//

import Foundation

class QueryItems {
    private var queryItems: [URLQueryItem]
    
    init() {
        self.queryItems = []
    }
    
    init(queryItems: [URLQueryItem]) {
        self.queryItems = queryItems
    }
    
    func getQueryitem() -> [URLQueryItem] {
        return queryItems
    }
    
    func isEqualQueryItem(index: Int, name: String, value: String) -> Bool {
        return queryItems[index].name == name && queryItems[index].value == value
    }
    
    func addQuery(newKey: String, newElement: String) {
        queryItems.append(URLQueryItem(name: newKey, value: newElement))
    }
    
    func createNew(path: String?) -> String {
        guard let validPath = path else {
            return ""
        }
        var newPath = validPath
        self.queryItems.forEach {
            guard let validValue = $0.value else {
                return
            }
            newPath.append("/\(validValue)")
        }
        return newPath
    }
}
