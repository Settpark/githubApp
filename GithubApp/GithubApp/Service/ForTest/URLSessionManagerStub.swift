//
//  URLSessionStub.swift
//  GithubAppTests
//
//  Created by 박정하 on 2021/11/11.
//

import Foundation
import RxSwift

final class URLSessionManagerStub: ReactiveURLSessionProtocol {
    var requestParam: (
        url: URL?,
        method: String?
    )?
    
    func response(request: URLRequest) -> Observable<(response: HTTPURLResponse, data: Data)> {
        requestParam = (
            url: request.url,
            method: request.httpMethod
        )
        return Observable.create { emmiter in
            return Disposables.create()
        }
    }
    
    func data(request: URLRequest) -> Observable<Data> {
        return Observable.just(Data())
    }
}



