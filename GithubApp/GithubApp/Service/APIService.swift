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
    
    func requestData<T: Decodable>(type: T.Type, path: Paths, query: [URLQueryItem]) -> Observable<T> {
        let endPoint = EndPointRepositories()
        let url = endPoint.createValidURL(path: path, query: query)
        
        let request = URLRequest.init(url: url)
        return self.urlsession.rx.data(request: request)
            .flatMap { data in
                return self.decodedData(type: type, data: data)
            }
    }
    
    func starUserrepo(path: Paths, token: [URLQueryItem], method: HttpMethod) -> Observable<(response: HTTPURLResponse, data: Data)> {
        let endPoint = StarEndPoint.init()
        let url = endPoint.createValidURL(path: .star, query: token)

        var request = URLRequest.init(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        if let validToken = token[2].value {
            let tokenAddHeader = token[2].name + " " + validToken
            request.addValue(tokenAddHeader, forHTTPHeaderField: "Authorization")
        }
        return self.urlsession.rx.response(request: request)
    }
    
    func requestAccessToken<T: Decodable>(type: T.Type, path: Paths, query: [URLQueryItem]) -> Observable<T> {
        let endPoint = EndPointAccessToken()
        let url = endPoint.createValidURL(path: path, query: query)
        
        var request = URLRequest.init(url: url)
        request.addValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        request.httpMethod = HttpMethod.post.rawValue
        return self.urlsession.rx.data(request: request)
            .flatMap { data in
                return self.decodedData(type: type, data: data)
            }
    }
    
    func requestUserData<T: Decodable>(type: T.Type, path: Paths, token: [URLQueryItem]) -> Observable<T> {
        let endPoint = EndPointUserRepo()
        let url = endPoint.createValidURL(path: path, query: token)

        var request = URLRequest.init(url: url)
        request.addValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        if let validToken = token.first, let validTokenvalue = token.first?.value {
            let tokenAddHeader = validToken.name + " " + validTokenvalue
            request.addValue(tokenAddHeader, forHTTPHeaderField: "Authorization")
        }
        return self.urlsession.rx.data(request: request)
            .flatMap { data in
                return self.decodedData(type: type, data: data)
            }
    }
    
    func getfetchedImage(url: String) -> Observable<Data> {
        let validURL = URL(string: url)!
        let request = URLRequest.init(url: validURL)
        return self.urlsession.rx.data(request: request)
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
