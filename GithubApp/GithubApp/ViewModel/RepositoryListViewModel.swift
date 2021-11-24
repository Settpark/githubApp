//
//  RepositoryListViewModel.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/06.
//

import Foundation
import RxSwift
import RxRelay

final class RepositoryListViewModel {
    
    private let useCase: SearchRepositoriesUsecase
    private let disposeBag: DisposeBag
    
    private let input: PublishSubject<String>
    let output: PublishRelay<[RepositoryListSectionData]>
    private var currentSearchFieldText: String
    private var currentSearchPage: Int
    private var currentPage: PublishRelay<Int>
    private var isScrolling: Bool
    weak var alertDelegate: AlertControllerDelegate?
    
    init(usecaseLayer: SearchRepositoriesUsecase) {
        self.useCase = usecaseLayer
        self.disposeBag = DisposeBag()
        
        self.input = PublishSubject<String>()
        self.output = PublishRelay<[RepositoryListSectionData]>()
        self.currentSearchFieldText = ""
        self.currentSearchPage = 1
        self.currentPage = PublishRelay<Int>()
        self.isScrolling = false
        
        input.flatMap { [weak self] text -> Observable<[RepositoryListSectionData]> in
            self?.currentSearchFieldText = text
            return self?.searchRepositoryList(with: text) ?? Observable.just([])
        }.subscribe { [weak self] sectionData in
            self?.output.accept(sectionData)
            self?.isScrolling = false
        } onError: { [weak self] error in
            self?.output.accept([])
            self?.isScrolling = false
            self?.alertDelegate?.showAlertController(message: .emptySearchBar)
        }.disposed(by: self.disposeBag)
        
        currentPage.flatMap { [weak self] page -> Observable<[RepositoryListSectionData]> in
            if self?.currentSearchFieldText == "" || page == 1 {
                return Observable.just([])
            }
            return self?.requestAdditionalList(next: page) ?? Observable.just([])
        }.subscribe { [weak self] sectionData in
            if sectionData.count == 0 {
                self?.alertDelegate?.showAlertController(message: .emptyList)
                return
            }
            self?.output.accept(sectionData)
            self?.isScrolling = false
        } onError: { [weak self] error in
            self?.output.accept([])
            self?.isScrolling = false
            self?.alertDelegate?.showAlertController(message: .emptyList)
        }.disposed(by: self.disposeBag)
    }
    
    func searchRepositoryList(with text: String) -> Observable<[RepositoryListSectionData]> {
//        self.currentPage.accept(1)
        return useCase.requestRepositories(value: text)
            .map { data in
                let temp = [RepositoryListSectionData.init(items: data)]
                return temp
            }
    }
    
    func requestAdditionalList(next: Int) -> Observable<[RepositoryListSectionData]> {
        return useCase.requestNextRepositories(value: currentSearchFieldText, page: next)
            .map { data in
                let temp = [RepositoryListSectionData.init(items: data)]
                return temp
            }
    }
    
    func search(with text: String?) {
        guard let validText = text, text != "" else {
            self.alertDelegate?.showAlertController(message: .emptySearchBar)
            return
        }
        self.input.onNext(validText)
    }
    
    func requestNextpage() {
        if self.isScrolling { return }
        self.isScrolling = true
        self.currentSearchPage = self.currentSearchPage + 1
        self.currentPage.accept(self.currentSearchPage)
    }
}
