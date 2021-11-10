//
//  ViewController.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/04.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class RepositoryListViewController: UIViewController, ViewModelBindable {
    
    var viewModel: RepositoryListViewModel!
    weak var loginDelegate: LoginDelegate?
    private var disposeBag: DisposeBag
    private var listDataSource: RxTableViewSectionedReloadDataSource<RepositoryListSectionData>!
    
    private let titleView: UIView
    private let titleLabel: UILabel
    private let titleLoginButton: UIButton
    private let searchButton: UIButton
    private let listTableview: UITableView
    private let searchField: UITextField
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.disposeBag = DisposeBag()
        self.titleView = UIView()
        self.titleLabel = UILabel()
        self.titleLoginButton = UIButton()
        self.listTableview = UITableView()
        self.searchButton = UIButton()
        self.searchField = UITextField()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.disposeBag = DisposeBag()
        self.titleView = UIView()
        self.titleLabel = UILabel()
        self.titleLoginButton = UIButton()
        self.listTableview = UITableView()
        self.searchButton = UIButton()
        self.searchField = UITextField()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.addSubviews()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.drawTitleView()
        self.drawSearchfield(constraint: self.titleView)
        self.drawSearchbutton(constraint: self.searchField)
        self.drawTableview(constraint: self.searchField)
        self.changeTitleView()
    }
    
    func initTableview() {
        self.listTableview.register(RepositoryListCell.self, forCellReuseIdentifier: RepositoryListCell.cellIdentifier)
        self.listTableview.rx
            .setDelegate(self)
            .disposed(by: self.disposeBag)
    }
    
    func initSearchButton() {
        self.searchButton.rx.tap
            .bind { [weak self] _ in
                self?.viewModel.setCurretpage(value: 0)
                guard let validText = self?.searchField.text, self?.searchField.text != "" else {
                    return
                }
                self?.viewModel.input.onNext([URLQueryItem(name: "q", value: validText)])
                self?.listTableview.contentOffset = .zero
            }.disposed(by: self.disposeBag)
    }
    
    func initLoginButton() {
        self.titleLoginButton.rx.tap
            .bind { [weak self] _ in
                self?.loginDelegate?.Login()
            }.disposed(by: disposeBag)
    }
    
    func initLoginToken() {
        self.loginDelegate?.loginToken
            .bind{ self.viewModel.inputToken.onNext($0)
            }
            .disposed(by: self.disposeBag)
    }
    
    func changeTitleView() {
        self.loginDelegate?.isLogin.bind { [weak self] islogin in
            if !islogin {
                self?.titleLoginButton.setTitle("로그인", for: .normal)
            } else {
                self?.titleLoginButton.setTitle("로그아웃", for: .normal)
            }
        }.disposed(by: self.disposeBag)
    }
    
    func bindViewModel() {
        initTableview()
        initDataSource()
        initSearchButton()
    }
}

extension RepositoryListViewController {
    private func initDataSource() {
        self.listDataSource = RxTableViewSectionedReloadDataSource<RepositoryListSectionData>(
            configureCell: { dataSource, tableView, indexPath, item in
                guard let cell: RepositoryListCell = tableView.dequeueReusableCell(withIdentifier: RepositoryListCell.cellIdentifier, for: indexPath) as? RepositoryListCell else {
                    return UITableViewCell()
                }
                cell.configureCell(with: item, buttonDelegate: self)
                return cell
            })
        
        self.viewModel.output
            .bind(to: self.listTableview.rx.items(dataSource: self.listDataSource))
            .disposed(by: self.disposeBag)
    }
}

extension RepositoryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let contentOffsetY = scrollView.contentOffset.y
        let tableViewContentSize = listTableview.contentSize.height
        
        if contentOffsetY > tableViewContentSize - scrollView.frame.height {
            self.viewModel.input.onNext([URLQueryItem(name: "q", value: self.searchField.text ?? "")])
        }
    }
}

extension RepositoryListViewController: StarManager {
    func checkStarRepository(owner: String, repo: String) -> Observable<Bool?> {
        if !(self.loginDelegate?.isLogin.value ?? false) {
            return Observable.just(nil)
        }
        let userName = URLQueryItem(name: "owner", value: owner)
        let userRepo = URLQueryItem(name: "repo", value: repo)
        return self.viewModel.checkStaredUserRepo(path: .star, query: [userName, userRepo], method: .get)
    }
    
    func unstarRespository(owner: String, repo: String) {
        if !(self.loginDelegate?.isLogin.value ?? false) {
            return
        }
        let userName = URLQueryItem(name: "owner", value: owner)
        let userRepo = URLQueryItem(name: "repo", value: repo)
        self.viewModel.starUserRepo(path: .star, query: [userName, userRepo], method: .delete)
    }
    
    func starRepository(owner: String, repo: String) {
        if !(self.loginDelegate?.isLogin.value ?? false) {
            return
        }
        let userName = URLQueryItem(name: "owner", value: owner)
        let userRepo = URLQueryItem(name: "repo", value: repo)
        self.viewModel.starUserRepo(path: .star, query: [userName, userRepo], method: .put)
    }
}

extension RepositoryListViewController {
    
    func drawSearchfield(constraint guide: UIView) {
        self.searchField.translatesAutoresizingMaskIntoConstraints = false
        self.searchField.leadingAnchor.constraint(equalTo: guide.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        self.searchField.topAnchor.constraint(equalTo: guide.safeAreaLayoutGuide.bottomAnchor, constant: 10).isActive = true
        self.searchField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: ViewRatio.searchFieldWidth.rawValue).isActive = true
        self.searchField.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: ViewRatio.searchFieldHeight.rawValue).isActive = true
        self.searchField.borderStyle = .roundedRect
    }
    
    func drawSearchbutton(constraint guide: UIView) {
        self.searchButton.backgroundColor = .darkGray
        self.searchButton.layer.masksToBounds = true
        self.searchButton.layer.cornerRadius = 5
        self.searchButton.setTitle("검색", for: .normal)
        self.searchButton.translatesAutoresizingMaskIntoConstraints = false
        self.searchButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        self.searchButton.centerYAnchor.constraint(equalTo: guide.centerYAnchor).isActive = true
        self.searchButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: ViewRatio.searchButtonWidth.rawValue).isActive = true
        self.searchButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: ViewRatio.searchFieldHeight.rawValue).isActive = true
    }
    
    func drawTableview(constraint guide: UIView) {
        self.listTableview.translatesAutoresizingMaskIntoConstraints = false
        self.listTableview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.listTableview.topAnchor.constraint(equalTo: guide.bottomAnchor, constant: 10).isActive = true
        self.listTableview.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        if let tabBarController = self.tabBarController {
            self.listTableview.bottomAnchor.constraint(equalTo: tabBarController.tabBar.topAnchor, constant: -5).isActive = true
        } else {
            self.listTableview.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        }
    }
    
    func drawTitleView() {
        self.titleView.backgroundColor = .darkGray
        self.titleView.translatesAutoresizingMaskIntoConstraints = false
        self.titleView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        self.titleView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.titleView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor).isActive = true
        self.titleView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: ViewRatio.topViewHeightRatio.rawValue).isActive = true
        
        self.titleLabel.text = "Github"
        self.titleLabel.font = .systemFont(ofSize: 17)
        self.titleLabel.sizeToFit()
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.centerXAnchor.constraint(equalTo: self.titleView.centerXAnchor).isActive = true
        self.titleLabel.centerYAnchor.constraint(equalTo: self.titleView.centerYAnchor).isActive = true
        
        self.titleLoginButton.sizeToFit()
        self.titleLoginButton.translatesAutoresizingMaskIntoConstraints = false
        self.titleLoginButton.centerYAnchor.constraint(equalTo: self.titleView.centerYAnchor).isActive = true
        self.titleLoginButton.trailingAnchor.constraint(equalTo: self.titleView.trailingAnchor, constant: -10).isActive = true
    }
    
    func addSubviews() {
        self.view.addSubview(self.titleView)
        self.titleView.addSubview(self.titleLabel)
        self.titleView.addSubview(self.titleLoginButton)
        self.view.addSubview(self.searchField)
        self.view.addSubview(self.searchButton)
        self.view.addSubview(self.listTableview)
    }
}
