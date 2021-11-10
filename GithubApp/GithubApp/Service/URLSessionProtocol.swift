//
//  URLsessionManagerStub.swift
//  GithubAppTests
//
//  Created by 박정하 on 2021/11/11.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {
    
}
