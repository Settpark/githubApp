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
    func requestData<T>(type: T.Type, query: QueryItems) -> Observable<T> where T : Decodable {
        return Observable.just("" as! T)
    }
    
    func requestUserData<T>(type: T.Type, token: QueryItems) -> Observable<T> where T : Decodable {
        return Observable.just("" as! T)
    }
    
    func starUserrepo(path: Paths, token: QueryItems) -> Observable<(response: HTTPURLResponse, data: Data)> {
        return Observable.just((response: HTTPURLResponse(), data: Data()))
    }
    
    private let urlsession: URLSessionProtocol
    
    init(urlSessionManager: URLSessionProtocol) {
        self.urlsession = urlSessionManager
    }
    
    func requestDataWithRx<T: Decodable>(type: T.Type, with request: URLRequest) -> Observable<T> {
        return URLSession.shared.rx.data(request: request)
            .flatMap { [unowned self] data in
                return self.decodedData(type: type, data: data)
            }
    }
    
    func requestRepositories<T: Decodable>(type: T.Type, query: QueryItems) -> Observable<T> {
        let endPoint = EndPoint(host: .api, path: .Repositories)
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
        
    func requestUserData<T: Decodable>(type: T.Type, path: Paths, token: [URLQueryItem]) -> Observable<T> {
//        let endPoint = EndPointUserRepo()
//        let url = endPoint.createValidURL(path: path, query: token)
//
//        var request = URLRequest.init(url: url)
//        request.addValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
//        if let validToken = token.first, let validTokenvalue = token.first?.value {
//            let tokenAddHeader = validToken.name + " " + validTokenvalue
//            request.addValue(tokenAddHeader, forHTTPHeaderField: "Authorization")
//        }
//        return URLSession.shared.rx.data(request: request)
//            .flatMap { data in
//                return self.decodedData(type: type, data: data)
//            }
        return Observable.just("" as! T)
    }
    
    func getfetchedImage(url: String) -> Observable<Data> {
        let validURL = URL(string: url)!
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
    
    func requetDataWithSession<T: Decodable>(request: URLRequest, type: T.Type, completion: @escaping (Result<T,Error>) -> Void) {
//        let endPoint = EndPointRepositories.init()
//        let query = URLQueryItem(name: "q", value: "forTest")
//        let request = URLRequest(url: endPoint.createValidURL(path: .Repositories, query: [query]))
//        let jsonDecoder = JSONDecoder()
//        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
//        self.urlsession.dataTask(with: request) { data, response, error in
//            do {
//                let result = try jsonDecoder.decode(type, from: data!)
//                completion(.success(result))
//            } catch (let error) {
//                completion(.failure(error))
//            }
//        }.resume()
    }
}
