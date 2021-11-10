//
//  RepositoryListViewModel.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/06.
//

import Foundation
import RxSwift

class RepositoryListViewModel {
    
    private let repository: RepositoryLayerType
    private let disposeBag: DisposeBag
    private var currentPage: Int
    private var userToken: AccessTokenModel?
    let inputToken: PublishSubject<AccessTokenModel>
    let input: PublishSubject<[URLQueryItem]>
    let output: PublishSubject<[RepositoryListSectionData]>
    
    init(repositoryLayer: RepositoryLayerType) {
        self.repository = repositoryLayer
        self.disposeBag = DisposeBag()
        self.currentPage = 0
        self.userToken = nil
        self.inputToken = PublishSubject<AccessTokenModel>()
        self.input = PublishSubject<[URLQueryItem]>()
        self.output = PublishSubject<[RepositoryListSectionData]>()
        
        input.flatMap { [unowned self] inputQuery -> Observable<[RepositoryListSectionData]> in
            var query = inputQuery
            self.currentPage = self.currentPage + 1
            let nextpage = URLQueryItem(name: "page", value: "\(currentPage)")
            query.append(nextpage)
            return self.searchRepositoryList(path: .Repositories, query: query)
        }
        .bind(to: output)
        .disposed(by: self.disposeBag)
        
        inputToken
            .subscribe() {
                self.userToken = $0
            }
            .disposed(by: self.disposeBag)
    }
    
    func searchRepositoryList(path: Paths, query: [URLQueryItem]) -> Observable<[RepositoryListSectionData]> {
        return repository.requestRepositoryList(path: path, query: query)
            .map { data in
                let temp = [RepositoryListSectionData.init(items: data)]
                return temp
            }
    }
    
    func checkStaredUserRepo(path: Paths, query: [URLQueryItem], method: HttpMethod) -> Observable<Bool> {
        guard let accessToken = userToken?.accessToken else {
            return Observable<Bool>.just(false)
        }
        let tempToken = URLQueryItem(name: "token", value: accessToken)
        var tempQuery = query
        tempQuery.append(tempToken)
        
        return repository.starUserrepo(path: path, query: tempQuery, method: method)
            .map { statuscode -> Bool in
                if statuscode > 400 { return false }
                else { return true }
            }
    }
    
    func starUserRepo(path: Paths, query: [URLQueryItem], method: HttpMethod) {
        guard let accessToken = userToken?.accessToken else {
            return
        }
        let tempToken = URLQueryItem(name: "token", value: accessToken)
        var tempQuery = query
        tempQuery.append(tempToken)
        
        repository.starUserrepo(path: path, query: tempQuery, method: method)
            .subscribe{ _ in }
            .disposed(by: self.disposeBag)
    }
    
    func setCurretpage(value: Int) {
        self.currentPage = value
        self.repository.clearRepositories()
    }
}
