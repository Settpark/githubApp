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
    let input: PublishSubject<[URLQueryItem]>
    let output: PublishSubject<[RepositoryListSectionData]>
    
    init(repositoryLayer: RepositoryLayerType) {
        self.repository = repositoryLayer
        self.disposeBag = DisposeBag()
        self.currentPage = 0
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
    }
    
    func searchRepositoryList(path: Paths, query: [URLQueryItem]) -> Observable<[RepositoryListSectionData]> {
        return repository.requestRepositoryList(path: path, query: query)
            .map { data in
                let temp = [RepositoryListSectionData.init(items: data)]
                return temp
            }
    }
    
    func setCurretpage(value: Int) {
        self.currentPage = value
        self.repository.clearRepositories()
    }
}
