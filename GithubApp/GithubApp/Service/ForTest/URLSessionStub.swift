//
//  URLSessionStub.swift
//  GithubAppTests
//
//  Created by 박정하 on 2021/11/11.
//

import Foundation

final class URLSessionManagerStub: URLSessionProtocol {
    var requestParam: (
        url: URL?,
        method: String?
    )?
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.requestParam = (
            url: request.url,
            method: request.httpMethod
        )
        return MockSessionDataTask.init()
    }
}
