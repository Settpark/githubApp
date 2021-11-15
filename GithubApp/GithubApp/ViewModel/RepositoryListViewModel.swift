//
//  RepositoryListViewModel.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/06.
//

import Foundation
import RxSwift

final class RepositoryListViewModel {
    
    private let useCase: SearchRepositoriesUsecase
    private let disposeBag: DisposeBag
    private var currentPage: Int
    private var userToken: AccessTokenModel?
    let inputToken: PublishSubject<AccessTokenModel>
    private let input: PublishSubject<String>
    let output: PublishSubject<[RepositoryListSectionData]>
    
    init(usecaseLayer: SearchRepositoriesUsecase) {
        self.useCase = usecaseLayer
        self.disposeBag = DisposeBag()
        self.currentPage = 0
        self.userToken = nil
        self.inputToken = PublishSubject<AccessTokenModel>()
        self.input = PublishSubject<String>()
        self.output = PublishSubject<[RepositoryListSectionData]>()
        
        input.flatMap { [unowned self] text -> Observable<[RepositoryListSectionData]> in
//            var query = inputQuery
//            self.currentPage = self.currentPage + 1
//            let nextpage = URLQueryItem(name: "page", value: "\(currentPage)")
//            query.append(nextpage)
            return self.searchRepositoryList(with: text)
        }.bind(to: output)
        .disposed(by: self.disposeBag)
        
        inputToken
            .subscribe() {
                self.userToken = $0
            }
            .disposed(by: self.disposeBag)
    }
    
    func searchRepositoryList(with text: String) -> Observable<[RepositoryListSectionData]> {
        return useCase.requestRepositories(value: text)
            .map { data in
                let temp = [RepositoryListSectionData.init(items: data)]
                return temp
            }
    }
    
    func checkStaredUserRepo(path: Paths, query: [URLQueryItem], method: HttpMethod) -> Observable<Bool?> {
//        guard let accessToken = userToken?.accessToken else {
//            return Observable.just(nil)
//        }
//        let tempToken = URLQueryItem(name: "token", value: accessToken)
//        var tempQuery = query
//        tempQuery.append(tempToken)
//
//        return repository.starUserrepo(path: path, query: tempQuery, method: method)
//            .map { statuscode -> Bool in
//                if statuscode > 400 { return false }
//                else { return true }
//            }
        Observable.just(false)
    }
    
    func starUserRepo(path: Paths, query: [URLQueryItem], method: HttpMethod) {
//        guard let accessToken = userToken?.accessToken else {
//            return
//        }
//        let tempToken = URLQueryItem(name: "token", value: accessToken)
//        var tempQuery = query
//        tempQuery.append(tempToken)
//
//        repository.starUserrepo(path: path, query: tempQuery, method: method)
//            .subscribe{ _ in }
//            .disposed(by: self.disposeBag)
    }
    
    func search(with text: String) {
        self.setCurretpage(value: 0)
        self.input.onNext(text)
    }
    
    private func setCurretpage(value: Int) {
        self.currentPage = 0
//        self.repository.clearRepositories()
    }
}
