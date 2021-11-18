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
        return Observable<(response: HTTPURLResponse, data: Data)>.just((HTTPURLResponse(), Data()))
    }
    
    func data(request: URLRequest) -> Observable<Data> {
        return Observable.just(Data())
    }
}



