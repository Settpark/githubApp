//
//  GithubAppTests.swift
//  GithubAppTests
//
//  Created by 박정하 on 2021/11/11.
//

import XCTest
import RxSwift
import RxBlocking

@testable import GithubApp

class GithubAppTests: XCTestCase {
    
    func test_올바른_url인가_repositoryList_요청시() {
        //given
        let sessionManager = URLSessionManagerStub()
        let service = APIService.init(urlSessionManager: sessionManager)
        var param: (url: URL?, method: String?)?
        
        //when
        let endpoint = EndPoint(host: .api, path: .SearchRepo)
        let query = QueryItems()
        query.addQuery(newKey: "q", newElement: "RxSwift")
        let url = endpoint.createValidURL(with: query)
        var request = URLRequest(url: url)
        
        request.httpMethod = HttpMethod.get.rawValue
        let serviceTest = service.requestResponseWithRx(request: request)
        
        //then
        let _ = serviceTest.toBlocking(timeout: 3)
        param = sessionManager.requestParam
        XCTAssertEqual(param?.url?.absoluteString, "https://api.github.com/search/repositories?q=RxSift")
        XCTAssertEqual(param?.method, "POST")
        
    }
    
    func test_뷰모델에서_받은_조건을_적절하게_가공하는가() {
        //given
        let repodummy = RepositoryDummy()
        let usecaseFakes = UsecaseFakes(repositoryLayer: repodummy)
        var queryItems = QueryItems()
        //when
        let usecaseTest = usecaseFakes.requestRepositories(value: "RxSwift")
        //then
        let _ = usecaseTest.toBlocking(timeout: 1)
        queryItems = usecaseFakes.query
        XCTAssertTrue(queryItems.isEqualQueryItem(index: 0, name: "q", value: "RxSwft"))
        XCTAssertTrue(queryItems.isEqualQueryItem(index: 1, name: "per_page", value: "1"))
    }
}
