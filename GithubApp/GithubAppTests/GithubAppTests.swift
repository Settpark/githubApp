//
//  GithubAppTests.swift
//  GithubAppTests
//
//  Created by 박정하 on 2021/11/11.
//

import XCTest
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
        let sessionManager = URLSessionManagerStub()
        let service = APIService.init(urlSessionManager: sessionManager)
        //when
        let endPoint = EndPointRepositories.init()
        let request = URLRequest(url: endPoint.createValidURL(path: .Repositories, query: []))
        service.requetDataWithSession(request: request, type: RepositoriesModel.self, completion: { _ in})
        let param = sessionManager.requestParam
        //then
        XCTAssertEqual(param?.url?.absoluteString, "https://api.github.com/search/repository?q=forTest&per_page=10")
        XCTAssertEqual(param?.method, "POST")
    }

}
