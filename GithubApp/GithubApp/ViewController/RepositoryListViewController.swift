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

final class RepositoryListViewController: UIViewController, ViewModelBindable, AlertControllerDelegate {
    
    var viewModel: RepositoryListViewModel!
    private weak var loginDelegate: LoginDelegate?
    private var disposeBag: DisposeBag
    private var listDataSource: RxTableViewSectionedReloadDataSource<RepositoryListSectionData>!
    
    private let titleView: UIView
    private let titleImage: UIImageView
    private let titleLabel: UILabel
    private let titleLoginButton: UIButton
    private let titleLogoutButton: UIButton
    private let searchButton: UIButton
    private let listTableview: UITableView
    private let searchField: UITextField
    private let activityIndicator: UIActivityIndicatorView
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.disposeBag = DisposeBag()
        self.titleView = UIView()
        self.titleImage = UIImageView()
        self.titleLabel = UILabel()
        self.titleLoginButton = UIButton()
        self.titleLogoutButton = UIButton()
        self.listTableview = UITableView()
        self.searchButton = UIButton()
        self.searchField = UITextField()
        self.activityIndicator = UIActivityIndicatorView()
        super.init(nibName: nil, bundle: nil)
        initTableview()
        initSearchButton()
        initActivityIndicator()
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
        self.addSubviews()
    }
    
    func showAlertController(message: AlertMessage) {
        DispatchQueue.main.async { [weak self] in
            if self?.activityIndicator.isAnimating == true {
                self?.activityIndicator.stopAnimating()
            }
            let alert = UIAlertController(title: "알림", message: message.rawValue, preferredStyle: .actionSheet)
            let success = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(success)
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    func initTableview() {
        self.listTableview.register(RepositoryListCell.self, forCellReuseIdentifier: RepositoryListCell.cellIdentifier)
        
        self.listTableview.rx
            .setDelegate(self)
            .disposed(by: self.disposeBag)
        
        self.listTableview.rx
            .didScroll.bind { [weak self] _ in
                self?.requestNextPage()
            }.disposed(by: self.disposeBag)
    }
    
    func initSearchButton() {
        self.searchField.rx.controlEvent(.editingDidEndOnExit)
            .bind { [weak self] _ in
                self?.searchRepositories(with: self?.searchField.text)
            }.disposed(by: self.disposeBag)
        
        self.searchField.rx.controlEvent(.touchDown)
            .bind {
                self.searchField.becomeFirstResponder()
            }.disposed(by: self.disposeBag)
        
        self.searchButton.rx.tap
            .bind { [weak self] _ in
                self?.searchRepositories(with: self?.searchField.text)
            }.disposed(by: self.disposeBag)
    }
    
    func searchRepositories(with text: String?) {
        self.searchField.resignFirstResponder()
        self.activityIndicator.startAnimating()
        self.viewModel.search(with: text)
        self.listTableview.contentOffset = .zero
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
        initLoginButton()
        initDataSource()
        drawViews()
        self.viewModel.alertDelegate = self
    }
    
    func drawViews() {
        self.loginDelegate?.drawTitleView(titleView: self.titleView, titleLabel: self.titleLabel, titleLoginButton: self.titleLoginButton, titleLogoutButton: self.titleLogoutButton, titleImage: self.titleImage, superView: self.view)
        self.drawSearchfield(constraint: self.titleView)
        self.drawSearchbutton(constraint: self.searchField)
        self.drawTableview(constraint: self.searchField)
    }
    
    func requestNextPage() {
        let contentOffsetY = listTableview.contentOffset.y
        let tableViewContentSize = listTableview.contentSize.height
        
        if contentOffsetY > tableViewContentSize - listTableview.frame.height {
            self.activityIndicator.startAnimating()
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
            .do(onNext: { [weak self] _ in
                self?.activityIndicator.stopAnimating()
                self?.listTableview.isHidden = false
            }).bind(to: self.listTableview.rx.items(dataSource: self.listDataSource))
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
        self.searchField.trailingAnchor.constraint(greaterThanOrEqualTo: self.searchButton.leadingAnchor, constant: -10).isActive = true
        self.searchField.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: ViewRatio.searchFieldHeight.rawValue).isActive = true
        self.searchField.borderStyle = .roundedRect
    }
    
    func drawSearchbutton(constraint guide: UIView) {
        self.searchButton.backgroundColor = .white
        self.searchButton.layer.masksToBounds = true
        self.searchButton.layer.cornerRadius = 5
        self.searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        self.searchButton.tintColor = .black
        self.searchButton.translatesAutoresizingMaskIntoConstraints = false
        self.searchButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        self.searchButton.centerYAnchor.constraint(equalTo: guide.centerYAnchor).isActive = true
        self.searchButton.heightAnchor.constraint(equalTo: self.searchField.heightAnchor).isActive = true
        self.searchButton.widthAnchor.constraint(equalTo: self.searchButton.heightAnchor).isActive = true
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
    
    func initActivityIndicator() {
        self.activityIndicator.center = CGPoint(x: self.view.center.x, y: self.view.center.y + self.view.frame.height * 0.05)
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.style = .large
        self.activityIndicator.color = .gray
    }
    
    func addSubviews() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.titleView)
        self.titleView.addSubview(self.titleLabel)
        self.titleView.addSubview(self.titleLoginButton)
        self.titleView.addSubview(self.titleLogoutButton)
        self.titleView.addSubview(self.titleImage)
        self.view.addSubview(self.searchField)
        self.view.addSubview(self.searchButton)
        self.view.addSubview(self.listTableview)
        self.view.addSubview(self.activityIndicator)
    }
}
