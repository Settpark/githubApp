//
//  RepositoryListViewModel.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/06.
//

import Foundation
import RxSwift

class RepositoryListViewModel {
    
    private let disposeBag: DisposeBag
    private let repository: RepositoryLayerType
    let input: PublishSubject<[URLQueryItem]>
    let output: PublishSubject<[RepositoryListSectionData]>
    
    init(repositoryLayer: RepositoryLayerType) {
        self.repository = repositoryLayer
        self.disposeBag = DisposeBag()
        self.input = PublishSubject<[URLQueryItem]>()
        self.output = PublishSubject<[RepositoryListSectionData]>()
        
        input.flatMap { [unowned self] inputText in
            self.searchRepositoryList(path: .Repositories, query: inputText)
        }
        .bind(to: output)
        .disposed(by: self.disposeBag)
    }
    
    func searchRepositoryList(path: Paths, query: [URLQueryItem]) -> Observable<[RepositoryListSectionData]> {
        return repository.requestRepositoryList(path: path, query: query)
            .map { data in
                let temp = [RepositoryListSectionData.init(items: data.items)]
                return temp
            }
    }
}
