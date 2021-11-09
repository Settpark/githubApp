//
//  LoginViewController.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/05.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class LoginViewController: UIViewController, ViewModelBindable {
    
    private let disposeBag: DisposeBag
    private let loginLabel: UILabel
    private let loginButton: UIButton
    private let topView: UIStackView
    private let userImage: UIImageView
    private let userName: UILabel
    private let userRepositoriesList: UITableView
    private var listDataSource: RxTableViewSectionedReloadDataSource<RepositoryListSectionData>!
    var viewModel: LoginViewModel!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.disposeBag = DisposeBag()
        self.loginLabel = UILabel()
        self.loginButton = UIButton()
        self.topView = UIStackView()
        self.topView.alignment = .leading
        self.topView.distribution = .fill
        self.topView.spacing = 10
        self.userImage = UIImageView()
        self.userName = UILabel()
        self.userRepositoriesList = UITableView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    func bindViewModel() {
        initLoginButton()
        initDrawOption()
        bindUserinfo()
        initTableview()
        initDataSource()
    }
    
    func initLoginButton() {
        let endpoint = EndPointAuthorization.init()
        self.loginButton.rx.tap
            .bind {
                let url = endpoint.createValidURL(path: .LoginPath, query: nil)
                UIApplication.shared.open(url)
            }.disposed(by: self.disposeBag)
    }
    
    func requestAccessToken(url: URL) -> Void {
        let code = url.absoluteString.components(separatedBy: "code=").last ?? ""
        self.viewModel.getAceessToken(path: .AccessToken, query: code)
            .bind(to: self.viewModel.inputToken)
            .disposed(by: self.disposeBag)
    }
    
    func initDrawOption() {
        self.viewModel.outputIslogin
            .observe(on: MainScheduler.instance)
            .bind {
                self.drawLoginView(currentState:$0)
            }.disposed(by: self.disposeBag)
    }
    
    func bindUserinfo() {
        self.viewModel.outputUserinfo
            .observe(on: MainScheduler.instance)
            .bind {
                self.userName.text = $0.login
            }.disposed(by: disposeBag)
        
        self.viewModel.outputUserinfo
            .flatMap {
                return self.viewModel.requestUserimage(url: $0.avatarUrl ?? "")
            }.observe(on: MainScheduler.instance)
            .bind {
                self.userImage.image = UIImage(data: $0)
            }.disposed(by: self.disposeBag)
    }
    
    func initTableview() {
        self.userRepositoriesList.register(RepositoryListCell.self, forCellReuseIdentifier: RepositoryListCell.cellIdentifier)
        self.userRepositoriesList.rx
            .setDelegate(self)
            .disposed(by: self.disposeBag)
    }
}

extension LoginViewController {
    func drawLoginView(currentState: Bool) {
        self.view.subviews.forEach { view in
            view.removeFromSuperview()
        }
        if !currentState {
            self.drawLoginButton()
            self.drawLoginLabel()
        }
        else {
            drawUserinfoView()
            drawListTableView()
            drawUserInfo()
        }
    }
    func drawLoginButton() {
        self.view.addSubview(loginButton)
        self.loginButton.setTitle("로그인", for: .normal)
        self.loginButton.backgroundColor = .systemGray6
        self.loginButton.layer.masksToBounds = true
        self.loginButton.layer.cornerRadius = 5
        self.loginButton.translatesAutoresizingMaskIntoConstraints = false
        self.loginButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.25).isActive = true
        self.loginButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.05).isActive = true
        self.loginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.loginButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    func drawLoginLabel() {
        self.view.addSubview(self.loginLabel)
        self.loginLabel.text = "로그인이 필요합니다."
        self.loginLabel.sizeToFit()
        self.loginLabel.translatesAutoresizingMaskIntoConstraints = false
        self.loginLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.loginLabel.bottomAnchor.constraint(equalTo: self.loginButton.topAnchor, constant: -10).isActive = true
    }
    
    
    func drawUserinfoView(constraint: UIView) {
        self.view.addSubview(topView)
        self.topView.translatesAutoresizingMaskIntoConstraints = false
        self.topView.topAnchor.constraint(equalTo: constraint.bottomAnchor).isActive = true
        self.topView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.topView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.topView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.15).isActive = true
    }
    
    func drawListTableView() {
        self.view.addSubview(self.userRepositoriesList)
        self.userRepositoriesList.translatesAutoresizingMaskIntoConstraints = false
        self.userRepositoriesList.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.userRepositoriesList.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.userRepositoriesList.topAnchor.constraint(equalTo: self.topView.bottomAnchor).isActive = true
        guard let superView = self.tabBarController as? MainTabBarController else {
            return
        }
        self.userRepositoriesList.bottomAnchor.constraint(equalTo: superView.tabBar.topAnchor, constant: -5).isActive = true
    }
    
    func drawUserInfo() {
        self.topView.addArrangedSubview(self.userImage)
        self.userImage.translatesAutoresizingMaskIntoConstraints = false
        self.userImage.heightAnchor.constraint(equalTo: self.topView.heightAnchor).isActive = true
        self.userImage.widthAnchor.constraint(equalTo: self.userImage.heightAnchor).isActive = true
        self.topView.addArrangedSubview(self.userName)
        self.userName.translatesAutoresizingMaskIntoConstraints = false
        self.userName.heightAnchor.constraint(equalTo: self.topView.heightAnchor).isActive = true
//        self.userName.leadingAnchor.constraint(equalTo: self.userImage.trailingAnchor).isActive = true
        self.userName.trailingAnchor.constraint(equalTo: self.topView.trailingAnchor).isActive = true
    }
    
    func drawUserinfoView() {
        guard let tabbar = self.tabBarController as? MainTabBarController else {
            return
        }
        tabbar.drawUserInfoTopview()
    }
}

extension LoginViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
    }
}

extension LoginViewController {
    private func initDataSource() {
        self.listDataSource = RxTableViewSectionedReloadDataSource<RepositoryListSectionData>(configureCell: { dataSource, tableView, indexPath, item in
                guard let cell: RepositoryListCell = tableView.dequeueReusableCell(withIdentifier: RepositoryListCell.cellIdentifier, for: indexPath) as? RepositoryListCell else {
                    return UITableViewCell()
                }
                cell.configureCell(with: item)
                return cell
            })
        
        self.viewModel.outputUserRepo
            .bind(to: self.userRepositoriesList.rx.items(dataSource: self.listDataSource))
            .disposed(by: self.disposeBag)
    }
}
