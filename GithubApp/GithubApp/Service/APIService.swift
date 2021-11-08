//
//  APIService.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/04.
//

import Foundation
import RxCocoa
import RxSwift

struct APIService: APIServiceType {
    private let urlsession: URLSession
    
    init() {
        self.urlsession = URLSession.shared
    }
    
    func requestData<T: Decodable>(type: T.Type, path: Paths, query: String) -> Observable<T> {
        let endPoint = EndPointRepositories()
        let url = endPoint.createValidURL(path: path, query: query)
        
        let request = URLRequest.init(url: url)
        return self.urlsession.rx.data(request: request)
            .flatMap { data in
                return self.decodedData(type: type, data: data)
            }
    }
    
    func requestAccessToken<T: Decodable>(type: T.Type, path: Paths, query: String) -> Observable<T> {
        let endPoint = EndPointAccessToken()
        let url = endPoint.createValidURL(path: path, query: query)
        
        var request = URLRequest.init(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"
        return self.urlsession.rx.data(request: request)
            .flatMap { data in
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
