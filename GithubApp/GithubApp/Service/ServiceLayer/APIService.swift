//
//  APIService.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/04.
//

import Foundation
import RxSwift
import RxCocoa

final class APIService: APIServiceType {
    
    private let urlSessionManager: ReactiveURLSessionProtocol
    
    init(urlSessionManager: ReactiveURLSessionProtocol) {
        self.urlSessionManager = urlSessionManager
    }
    
    func requestDataWithRx<T: Decodable>(type: T.Type, with request: URLRequest) -> Observable<T> {
        return urlSessionManager.data(request: request)
            .flatMap { [unowned self] data in
                return self.decodedData(type: type, data: data)
            }
    }
    
    func requestResponseWithRx(request: URLRequest) -> Observable<(response: HTTPURLResponse, data: Data)> {
        return URLSession.shared.rx.response(request: request)
    }
    
    func requestRepositories<T: Decodable>(type: T.Type, query: QueryItems) -> Observable<T> {
        let endPoint = EndPoint(host: .api, path: .SearchRepo)
        let url = endPoint.createValidURL(with: query)
        
        let request = URLRequest.init(url: url)
        return requestDataWithRx(type: type, with: request)
    }
    
    func requestAccessToken<T: Decodable>(type: T.Type, query: QueryItems) -> Observable<T> {
        let endPoint = EndPoint.init(host: .loginAuthorization, path: .AccessTokenPath)
        let validURL = endPoint.createValidURL(with: query)
        var request = URLRequest(url: validURL)
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        return self.requestDataWithRx(type: type, with: request)
    }
        
    func requestUserData<T: Decodable>(endPoint: EndPoint, type: T.Type, token: String) -> Observable<T> {
        let url = endPoint.createValidURL(with: nil)
        var request = URLRequest.init(url: url)
        request.addValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        request.addValue("token \(token)", forHTTPHeaderField: "Authorization")

        return self.requestDataWithRx(type: type, with: request)
    }
    
    func getfetchedImage(url: String?) -> Observable<Data> {
        let validURL = URL(string: url!)! // 기본 이미지 줘야함 데이터 형태로
        let request = URLRequest.init(url: validURL)
        return URLSession.shared.rx.data(request: request)
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

    func starUserrepo(httpMethod: HttpMethod, query: QueryItems, token: String) -> Observable<(response: HTTPURLResponse, data: Data)> {
        let endPoint = EndPoint.init(host: .api, path: .Star)
        let url = endPoint.createValidURLChange(path: query)
        var request = URLRequest.init(url: url)
        
        request.httpMethod = httpMethod.rawValue
        request.addValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        request.addValue("token \(token)", forHTTPHeaderField: "Authorization")
        
        return self.requestResponseWithRx(request: request)
    }
}
