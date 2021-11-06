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
    
    init(repositoryLayer: RepositoryLayerType) {
        self.repository = repositoryLayer
    }
    
    func searchResult(path: Paths, query: String) -> Observable<[RepositoryListSectionData]> {
        return repository.RepositoryList(path: path, query: query)
            .map { data in
                let temp = [RepositoryListSectionData.init(items: data.items)]
                return temp
            }
    }
}
