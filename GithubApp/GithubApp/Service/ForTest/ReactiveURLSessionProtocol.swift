//
//  URLsessionManagerStub.swift
//  GithubAppTests
//
//  Created by 박정하 on 2021/11/11.
//

import Foundation
import RxSwift

protocol ReactiveURLSessionProtocol {
    func response(request: URLRequest) -> Observable<(response: HTTPURLResponse, data: Data)>
    func data(request: URLRequest) -> Observable<Data>
}

extension Reactive: ReactiveURLSessionProtocol where Base: URLSession {
    
}
