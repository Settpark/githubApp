//
//  APIService.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/04.
//

import Foundation
import RxCocoa
import RxSwift

class APIService: APIServiceType {
    private let endPoint: EndPoint
    private let urlsession: URLSession
    
    init(endPoint: EndPoint) {
        self.endPoint = endPoint
        self.urlsession = URLSession.shared
    }
    
    func requestData<T: Decodable>(type: T.Type, path: Paths, query: String) -> Observable<T> {
        let url = self.endPoint.createValidURL(path: path, query: query)
        let request = URLRequest.init(url: url)
        return self.urlsession.rx.data(request: request)
            .flatMap { [unowned self] data in
                return self.decodedData(type: type, data: data)
            }
    }
    
    func decodedData<T: Decodable>(type: T.Type, data: Data) -> Observable<T> {
        let decoder = JSONDecoder()
        do {
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let result = try decoder.decode(type, from: data)
            return Observable.just(result)
        } catch (let err) {
            return Observable.error(err)
        }
    }
}
