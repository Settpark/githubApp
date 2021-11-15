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
    private var currentPage: BehaviorRelay<Int>
    
    init(usecaseLayer: SearchRepositoriesUsecase) {
        self.useCase = usecaseLayer
        self.disposeBag = DisposeBag()
        
        self.input = PublishSubject<String>()
        self.output = PublishRelay<[RepositoryListSectionData]>()
        self.currentSearchFieldText = ""
        self.currentPage = BehaviorRelay(value: 1)
        
        input.flatMap { [weak self] text -> Observable<[RepositoryListSectionData]> in
            self?.currentSearchFieldText = text
            return self?.searchRepositoryList(with: text) ?? Observable.just([])
        }.subscribe { [weak self] sectionData in
            self?.output.accept(sectionData)
        } onError: { [weak self] error in
            //alert Controller
            self?.output.accept([])
        }.disposed(by: self.disposeBag)
        
        currentPage.flatMap { [weak self] page -> Observable<[RepositoryListSectionData]> in
            if self?.currentSearchFieldText == "" || page == 1 {
                return Observable.just([])
            }
            return self?.requestAdditionalList(next: page) ?? Observable.just([])
        }.subscribe { [weak self] sectionData in
            self?.output.accept(sectionData)
        } onError: { [weak self] error in
            self?.output.accept([])
            //alert Controller
        }.disposed(by: self.disposeBag)
    }
    
    func searchRepositoryList(with text: String) -> Observable<[RepositoryListSectionData]> {
        self.currentPage.accept(1)
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
    
    func search(with text: String?) {
        guard let validText = text, text != "" else {
            return
        }
        self.input.onNext(validText)
    }
    
    private func setCurretpage(value: Int) {
        //        self.currentPage = 0
        //        self.repository.clearRepositories()
    }
    
    func requestNextpage() {
        self.currentPage.accept(currentPage.value + 1)
    }
}
