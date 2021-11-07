//
//  ViewController.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/04.
//

import UIKit
import RxSwift
import RxDataSources

final class RepositoryListViewController: UIViewController {
    
    private var disposeBag: DisposeBag
    private var listDataSource: RxTableViewSectionedReloadDataSource<RepositoryListSectionData>!
    private let viewModel: RepositoryListViewModel
    
    private var titleView: UIView
    private var titleLabel: UILabel
    private var loginButton: UIButton
    private var searchField: UITextField
    private var searchButton: UIButton
    private var listTableview: UITableView
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.disposeBag = DisposeBag()
        self.viewModel = RepositoryListViewModel(repositoryLayer: RepositoryLayer.init(apiService: APIService(endPoint: EndPoint.init())))
        self.titleView = UIView()
        self.titleLabel = UILabel()
        self.loginButton = UIButton()
        self.listTableview = UITableView()
        self.searchButton = UIButton()
        self.searchField = UITextField()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.disposeBag = DisposeBag()
        self.viewModel = RepositoryListViewModel(repositoryLayer: RepositoryLayer.init(apiService: APIService(endPoint: EndPoint.init())))
        self.titleView = UIView()
        self.titleLabel = UILabel()
        self.loginButton = UIButton()
        self.listTableview = UITableView()
        self.searchButton = UIButton()
        self.searchField = UITextField()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        initTableview()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.drawTopview(constraint: self.view)
        self.drawTitleview(constraint: self.titleView)
        self.drawLoginview(constraint: self.titleView)
        self.drawSearchfield(constraint: self.titleView)
        self.drawSearchbutton(constraint: self.searchField)
        self.drawTableview(constraint: self.searchField)
    }
    
    func initTableview() {
        self.listTableview.register(RepositoryListCell.self, forCellReuseIdentifier: RepositoryListCell.cellIdentifier)
        self.listTableview.rx
            .setDelegate(self)
            .disposed(by: self.disposeBag)
        initDataSource()
    }
}

extension RepositoryListViewController {
    private func initDataSource() {
        self.listDataSource = RxTableViewSectionedReloadDataSource<RepositoryListSectionData>(
            configureCell: { dataSource, tableView, indexPath, item in
                guard let cell: RepositoryListCell = tableView.dequeueReusableCell(withIdentifier: RepositoryListCell.cellIdentifier, for: indexPath) as? RepositoryListCell else {
                    return UITableViewCell()
                }
                cell.configureCell(with: item)
                return cell
            })
        
        self.viewModel
            .searchResult(path: .Repositories, query: "RxSwift")
            .bind(to: self.listTableview.rx.items(dataSource: listDataSource))
            .disposed(by: disposeBag)
        
    }
}

extension RepositoryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
}

extension RepositoryListViewController {
    func drawTopview(constraint guide: UIView) {
        self.view.addSubview(self.titleView)
        self.titleView.backgroundColor = .systemPink
        self.titleView.translatesAutoresizingMaskIntoConstraints = false
        self.titleView.centerXAnchor.constraint(equalTo: guide.safeAreaLayoutGuide.centerXAnchor).isActive = true
        self.titleView.topAnchor.constraint(equalTo: guide.safeAreaLayoutGuide.topAnchor).isActive = true
        self.titleView.widthAnchor.constraint(equalTo: guide.safeAreaLayoutGuide.widthAnchor).isActive = true
        self.titleView.heightAnchor.constraint(equalTo: guide.safeAreaLayoutGuide.heightAnchor, multiplier: ViewRatio.topViewHeightRatio.rawValue).isActive = true
    }
    
    func drawTitleview(constraint guide: UIView) {
        self.titleView.addSubview(self.titleLabel)
        self.titleLabel.text = "Github"
        self.titleLabel.font = .systemFont(ofSize: 17)
        self.titleLabel.sizeToFit()
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        self.titleLabel.centerYAnchor.constraint(equalTo: guide.centerYAnchor).isActive = true
    }
    
    func drawLoginview(constraint guide: UIView) {
        self.titleView.addSubview(self.loginButton)
        self.loginButton.setTitle("로그인", for: .normal)
        self.loginButton.sizeToFit()
        self.loginButton.translatesAutoresizingMaskIntoConstraints = false
        self.loginButton.centerYAnchor.constraint(equalTo: self.titleView.centerYAnchor).isActive = true
        self.loginButton.trailingAnchor.constraint(equalTo: self.titleView.trailingAnchor, constant: -10).isActive = true
    }
    
    func drawSearchfield(constraint guide: UIView) {
        self.view.addSubview(self.searchField)
        self.searchField.translatesAutoresizingMaskIntoConstraints = false
        self.searchField.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 10).isActive = true
        self.searchField.topAnchor.constraint(equalTo: guide.bottomAnchor, constant: 10).isActive = true
        self.searchField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: ViewRatio.searchFieldWidth.rawValue).isActive = true
        self.searchField.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: ViewRatio.searchFieldHeight.rawValue).isActive = true
        self.searchField.borderStyle = .roundedRect
    }
    
    func drawSearchbutton(constraint guide: UIView) {
        self.view.addSubview(self.searchButton)
        self.searchButton.backgroundColor = .systemPink
        self.searchButton.translatesAutoresizingMaskIntoConstraints = false
        self.searchButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        self.searchButton.centerYAnchor.constraint(equalTo: guide.centerYAnchor).isActive = true
        self.searchButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: ViewRatio.searchButtonWidth.rawValue).isActive = true
        self.searchButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: ViewRatio.searchFieldHeight.rawValue).isActive = true
    }
    
    func drawTableview(constraint guide: UIView) {
        self.view.addSubview(self.listTableview)
        
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
}
