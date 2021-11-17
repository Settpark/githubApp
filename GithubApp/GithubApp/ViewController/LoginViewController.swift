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
    var viewModel: LoginViewModel!
    
    private let titleView: UIView
    private let titleLabel: UILabel
    private let titleImage: UIImageView
    private let titleLoginButton: UIButton
    private let titleLogoutButton: UIButton
    private let loginLabel: UILabel
    private let centerLoginButton: UIButton
    private let userInfoview: UIStackView
    private let userImage: UIImageView
    private let userName: UILabel
    private let userRepositoriesList: UITableView
    private var listDataSource: RxTableViewSectionedReloadDataSource<RepositoryListSectionData>!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.disposeBag = DisposeBag()
        self.titleView = UIView()
        self.titleLabel = UILabel()
        self.titleLoginButton = UIButton()
        self.titleLogoutButton = UIButton()
        self.titleImage = UIImageView()
        self.loginLabel = UILabel()
        self.centerLoginButton = UIButton()
        self.userInfoview = UIStackView()
        self.userInfoview.alignment = .leading
        self.userInfoview.distribution = .fill
        self.userInfoview.spacing = 15
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
        addSubviews()
    }
    
    func bindViewModel() {
        self.bindDrawElements()
        self.initTableview()
        self.initDataSource()
        self.initLoginoutButton()
        self.bindUserinfo()
        self.drawViews()
    }
    
    func bindDrawElements() {
        self.viewModel.isLogin()
            .asDriver()
            .drive { [weak self] state in
                self?.drawLoginView(currentState: state)
            }.disposed(by: self.disposeBag)
    }
    
    func initTableview() {
        self.userRepositoriesList.register(RepositoryListCell.self, forCellReuseIdentifier: RepositoryListCell.cellIdentifier)
        self.userRepositoriesList.rx
            .setDelegate(self)
            .disposed(by: self.disposeBag)
    }
    
    func initLoginoutButton() {
        self.centerLoginButton.rx.tap
            .bind { [weak self] _ in
                self?.login(window: self?.view.window)
            }.disposed(by: self.disposeBag)
        
        self.titleLoginButton.rx.tap
            .bind { [weak self] _ in
                guard let window = self?.view.window else { return }
                self?.viewModel.login(in: window)
            }.disposed(by: self.disposeBag)
        
        self.titleLogoutButton.rx.tap
            .bind { [weak self] _ in
                self?.viewModel.logout()
            }.disposed(by: self.disposeBag)
    }
    
    func bindUserinfo() {
        self.viewModel.requestUserData()
            .observe(on: MainScheduler.instance)
            .bind { [weak self] userData in
                self?.userName.text = userData.login
                self?.userImage.image = userData.avatar
            }.disposed(by: self.disposeBag)
    }
    
}

extension LoginViewController {
    func drawLoginView(currentState: Bool) {
        self.view.subviews.forEach { $0.isHidden = true }
        self.titleView.isHidden = false
        if !currentState {
            self.titleLoginButton.isHidden = false
            self.titleLogoutButton.isHidden = true
            self.centerLoginButton.isHidden = false
            self.loginLabel.isHidden = false
        } else {
            self.titleLogoutButton.isHidden = false
            self.titleLoginButton.isHidden = true
            self.userInfoview.isHidden = false
            self.userRepositoriesList.isHidden = false
            self.userImage.isHidden = false
            self.userName.isHidden = false
        }
    }
    
    func drawLoginButton() {
        self.centerLoginButton.setTitle("로그인", for: .normal)
        self.centerLoginButton.backgroundColor = .darkGray
        self.centerLoginButton.layer.masksToBounds = true
        self.centerLoginButton.layer.cornerRadius = 5
        self.centerLoginButton.translatesAutoresizingMaskIntoConstraints = false
        self.centerLoginButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.25).isActive = true
        self.centerLoginButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.05).isActive = true
        self.centerLoginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.centerLoginButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    func drawLoginLabel() {
        self.loginLabel.text = "로그인이 필요합니다."
        self.loginLabel.sizeToFit()
        self.loginLabel.translatesAutoresizingMaskIntoConstraints = false
        self.loginLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.loginLabel.bottomAnchor.constraint(equalTo: self.centerLoginButton.topAnchor, constant: -10).isActive = true
    }
    
    func drawUserinfoView() {
        self.userInfoview.translatesAutoresizingMaskIntoConstraints = false
        self.userInfoview.topAnchor.constraint(equalTo: self.titleView.bottomAnchor, constant: 5).isActive = true
        self.userInfoview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.userInfoview.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.userInfoview.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.15).isActive = true
    }
    
    func drawListTableView() {
        self.userRepositoriesList.translatesAutoresizingMaskIntoConstraints = false
        self.userRepositoriesList.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.userRepositoriesList.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.userRepositoriesList.topAnchor.constraint(equalTo: self.userInfoview.bottomAnchor).isActive = true
        if let tabBarController = self.tabBarController {
            self.userRepositoriesList.bottomAnchor.constraint(equalTo: tabBarController.tabBar.topAnchor, constant: -5).isActive = true
        } else {
            self.userRepositoriesList.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        }
    }
    
    func drawUserInfo() {
        self.userImage.translatesAutoresizingMaskIntoConstraints = false
        self.userImage.heightAnchor.constraint(equalTo: self.userInfoview.heightAnchor).isActive = true
        self.userImage.widthAnchor.constraint(equalTo: self.userImage.heightAnchor).isActive = true
        self.userName.translatesAutoresizingMaskIntoConstraints = false
        self.userName.heightAnchor.constraint(equalTo: self.userInfoview.heightAnchor).isActive = true
    }
    
    func drawTitleView(titleView: UIView, titleLabel: UILabel, titleLoginButton: UIButton, titleLogoutButton: UIButton, titleImage: UIImageView, superView: UIView) {
        
        titleView.backgroundColor = .white
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.centerXAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.centerXAnchor).isActive = true
        titleView.topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        titleView.widthAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.widthAnchor).isActive = true
        titleView.heightAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.heightAnchor, multiplier: ViewRatio.topViewHeightRatio.rawValue).isActive = true
        
        titleImage.image = UIImage(named: "github")
        titleImage.translatesAutoresizingMaskIntoConstraints = false
        titleImage.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 10).isActive = true
        titleImage.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        titleImage.widthAnchor.constraint(equalTo: superView.widthAnchor, multiplier: 0.1).isActive = true
        titleImage.heightAnchor.constraint(equalTo: titleImage.widthAnchor).isActive = true
        
        titleLabel.text = "Github"
        titleLabel.font = .boldSystemFont(ofSize: 17)
        titleLabel.sizeToFit()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: titleImage.trailingAnchor, constant: 10).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        
        titleLoginButton.setTitle("로그인", for: .normal)
        titleLoginButton.setTitleColor(.black, for: .normal)
        titleLoginButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
        titleLoginButton.sizeToFit()
        titleLoginButton.translatesAutoresizingMaskIntoConstraints = false
        titleLoginButton.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        titleLoginButton.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -10).isActive = true
        
        titleLogoutButton.setTitle("로그아웃", for: .normal)
        titleLogoutButton.setTitleColor(.black, for: .normal)
        titleLogoutButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
        titleLogoutButton.sizeToFit()
        titleLogoutButton.translatesAutoresizingMaskIntoConstraints = false
        titleLogoutButton.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        titleLogoutButton.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -10).isActive = true
    }
    
    func addSubviews() {
        self.view.addSubview(self.loginLabel)
        self.view.addSubview(centerLoginButton)
        self.view.addSubview(self.titleView)
        self.titleView.addSubview(self.titleLabel)
        self.titleView.addSubview(self.titleLoginButton)
        self.titleView.addSubview(self.titleLogoutButton)
        self.titleView.addSubview(self.titleImage)
        self.view.addSubview(self.userRepositoriesList)
        self.view.addSubview(userInfoview)
        self.userInfoview.addArrangedSubview(self.userImage)
        self.userInfoview.addArrangedSubview(self.userName)
    }
    
    func drawViews() {
        self.view.backgroundColor = .white
        self.drawLoginButton()
        self.drawLoginLabel()
        self.drawUserinfoView()
        self.drawListTableView()
        self.drawUserInfo()
        self.drawTitleView(titleView: self.titleView, titleLabel: self.titleLabel, titleLoginButton: self.titleLoginButton, titleLogoutButton: self.titleLogoutButton, titleImage: self.titleImage, superView: self.view)
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
            cell.configureCell(with: item, buttonDelegate: self)
            return cell
        })
        
        self.viewModel.requestUserRepo()
            .bind(to: self.userRepositoriesList.rx.items(dataSource: self.listDataSource))
            .disposed(by: self.disposeBag)
    }
}

extension LoginViewController: LoginDelegate  {
    func login(window: UIWindow?) {
        guard let validWindow = window else { return }
        self.viewModel.login(in: validWindow)
    }
    
    func islogin() -> BehaviorRelay<Bool> {
        return self.viewModel.isLogin()
    }
    
    func logout() {
        self.viewModel.logout()
    }
    
    func starRepository(owner: String, repo: String) -> Observable<Void> {
        self.viewModel.starRepo(owner: owner, repo: repo)
    }
    
    func unstarRepository(owner: String, repo: String) -> Observable<Void> {
        self.viewModel.unstarRepo(owner: owner, repo: repo)
    }
    
    func checkStarRepository(owner: String, repo: String) -> Observable<Bool> {
        return self.viewModel.isStarRepo(owner: owner, repo: repo)
    }
}
