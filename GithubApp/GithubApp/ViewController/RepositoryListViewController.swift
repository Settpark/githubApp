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
    private weak var loginDelegate: LoginDelegate?
    private var disposeBag: DisposeBag
    private var listDataSource: RxTableViewSectionedReloadDataSource<RepositoryListSectionData>!
    
    private let titleView: UIView
    private let titleLabel: UILabel
    private let titleLoginButton: UIButton
    private let titleLogoutButton: UIButton
    private let searchButton: UIButton
    private let listTableview: UITableView
    private let searchField: UITextField
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.disposeBag = DisposeBag()
        self.titleView = UIView()
        self.titleLabel = UILabel()
        self.titleLoginButton = UIButton()
        self.titleLogoutButton = UIButton()
        self.listTableview = UITableView()
        self.searchButton = UIButton()
        self.searchField = UITextField()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    convenience init(delegate: LoginDelegate) {
        self.init(nibName: nil, bundle: nil)
        self.loginDelegate = delegate
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
    }
    
    func initTableview() {
        self.listTableview.register(RepositoryListCell.self, forCellReuseIdentifier: RepositoryListCell.cellIdentifier)
        self.listTableview.rx
            .setDelegate(self)
            .disposed(by: self.disposeBag)
        self.listTableview.rx
            .didEndScrollingAnimation.bind { [weak self] _ in
                self?.requestNextPage()
            }.disposed(by: self.disposeBag)
    }
    
    func initSearchButton() {
        self.searchField.rx.controlEvent(.editingDidEndOnExit)
            .bind { [weak self] _ in
                self?.viewModel.search(with: self?.searchField.text)
                self?.listTableview.contentOffset = .zero
            }.disposed(by: self.disposeBag)
        
        self.searchButton.rx.tap
            .bind { [weak self] _ in
                self?.viewModel.search(with: self?.searchField.text)
                self?.listTableview.contentOffset = .zero
            }.disposed(by: self.disposeBag)
    }
    
    func initLoginButton() {
        self.loginDelegate?.islogin()
            .asDriver()
            .drive { [weak self] state in
                self?.drawLoginButton(state: state)
            }.disposed(by: self.disposeBag)
        
        self.titleLoginButton.rx.tap
            .bind { [weak self] _ in
                self?.loginDelegate?.login(window: self?.view.window)
            }.disposed(by: self.disposeBag)
        
        self.titleLogoutButton.rx.tap
            .bind { [weak self] _ in
                self?.loginDelegate?.logout()
            }.disposed(by: self.disposeBag)
    }
    
    func drawLoginButton(state: Bool) {
        if state {
            self.titleLoginButton.isHidden = true
            self.titleLogoutButton.isHidden = false
        } else {
            self.titleLoginButton.isHidden = false
            self.titleLogoutButton.isHidden = true
        }
    }
    
    func bindViewModel() {
        initTableview()
        initDataSource()
        initSearchButton()
        initLoginButton()
    }
    
    func requestNextPage() {
        let contentOffsetY = listTableview.contentOffset.y
        let tableViewContentSize = listTableview.contentSize.height

        if contentOffsetY > tableViewContentSize - listTableview.frame.height {
            self.viewModel.requestNextpage()
        }
    }
}

extension RepositoryListViewController {
    private func initDataSource() {
        self.listDataSource = RxTableViewSectionedReloadDataSource<RepositoryListSectionData>(
            configureCell: { dataSource, tableView, indexPath, item in
                guard let cell: RepositoryListCell = tableView.dequeueReusableCell(withIdentifier: RepositoryListCell.cellIdentifier, for: indexPath) as? RepositoryListCell, let delegate = self.loginDelegate else {
                    return UITableViewCell()
                }
                cell.configureCell(with: item, buttonDelegate: delegate)
                return cell
            })
        
        self.viewModel.output
            .observe(on: MainScheduler.instance)
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
            self.viewModel.requestNextpage()
        }
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
        self.titleLoginButton.setTitle("로그인", for: .normal)
        self.titleLoginButton.translatesAutoresizingMaskIntoConstraints = false
        self.titleLoginButton.centerYAnchor.constraint(equalTo: self.titleView.centerYAnchor).isActive = true
        self.titleLoginButton.trailingAnchor.constraint(equalTo: self.titleView.trailingAnchor, constant: -10).isActive = true
        
        self.titleLogoutButton.sizeToFit()
        self.titleLogoutButton.setTitle("로그아웃", for: .normal)
        self.titleLogoutButton.translatesAutoresizingMaskIntoConstraints = false
        self.titleLogoutButton.centerYAnchor.constraint(equalTo: self.titleView.centerYAnchor).isActive = true
        self.titleLogoutButton.trailingAnchor.constraint(equalTo: self.titleView.trailingAnchor, constant: -10).isActive = true
    }
    
    func addSubviews() {
        self.view.addSubview(self.titleView)
        self.titleView.addSubview(self.titleLabel)
        self.titleView.addSubview(self.titleLoginButton)
        self.titleView.addSubview(self.titleLogoutButton)
        self.view.addSubview(self.searchField)
        self.view.addSubview(self.searchButton)
        self.view.addSubview(self.listTableview)
    }
}
