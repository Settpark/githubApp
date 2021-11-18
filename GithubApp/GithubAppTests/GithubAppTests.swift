//
//  GithubAppTests.swift
//  GithubAppTests
//
//  Created by 박정하 on 2021/11/11.
//

import XCTest
import RxSwift

@testable import GithubApp

class GithubAppTests: XCTestCase {

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }

    func testExample() throws {
        
    }

    func testPerformanceExample() throws {
        
        measure {
            
        }
    }
    
    func test_올바른_url인가_repositoryList_요청시() {
        //given
        let disposeBag = DisposeBag()
        
        let promise = expectation(description: "성공!")
        promise.assertForOverFulfill = false
        
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
        service.requestResponseWithRx(request: request)
            .subscribe{ _ in
                sessionManager.requestParam = (
                    url: request.url,
                    method: request.httpMethod
                )
                param = sessionManager.requestParam
                promise.fulfill()
            }.disposed(by: disposeBag)
        
        //then
        wait(for: [promise], timeout: 3)
        XCTAssertEqual(param?.url?.absoluteString, "https://api.github.com/search/repositories?q=RxSwift")
        XCTAssertEqual(param?.method, "GET")
    }

}
