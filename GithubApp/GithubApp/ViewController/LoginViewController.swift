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

final class LoginViewController: UIViewController, ViewModelBindable, LoginDelegate {
    
    private let disposeBag: DisposeBag
    
    private let titleView: UIView
    private let titleLabel: UILabel
    private let titleLoginButton: UIButton
    private let loginLabel: UILabel
    private let centerLoginButton: UIButton
    private let userInfoview: UIStackView
    private let userImage: UIImageView
    private let userName: UILabel
    private let userRepositoriesList: UITableView
    private var listDataSource: RxTableViewSectionedReloadDataSource<RepositoryListSectionData>!
    
    var viewModel: LoginViewModel!
    var isLogin: BehaviorRelay<Bool>
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.disposeBag = DisposeBag()
        self.titleView = UIView()
        self.titleLabel = UILabel()
        self.titleLoginButton = UIButton()
        self.loginLabel = UILabel()
        self.centerLoginButton = UIButton()
        self.userInfoview = UIStackView()
        self.userInfoview.alignment = .leading
        self.userInfoview.distribution = .fill
        self.userInfoview.spacing = 10
        self.userImage = UIImageView()
        self.userName = UILabel()
        self.userRepositoriesList = UITableView()
        self.isLogin = BehaviorRelay<Bool>(value: false)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.addSubviews()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.drawViews()
    }
    
    func Login() {
        let endpoint = EndPointAuthorization.init()
        let url = endpoint.createValidURL(path: .LoginPath, query: nil)
        UIApplication.shared.open(url)
        self.isLogin.accept(true)
    }
    
    func bindViewModel() {
        self.initLoginButton()
        self.bindUserinfo()
        self.initTableview()
        self.initDataSource()
        self.initDrawOption()
    }
    
    func initLoginButton() {
        self.centerLoginButton.rx.tap
            .bind {
                self.Login()
            }.disposed(by: self.disposeBag)
    }
    
    func requestAccessToken(url: URL) -> Void {
        let code = url.absoluteString.components(separatedBy: "code=").last ?? ""
        self.viewModel.getAceessToken(path: .AccessToken, query: code)
            .bind(to: self.viewModel.inputToken)
            .disposed(by: self.disposeBag)
    }
    
    func initDrawOption() {
        self.isLogin
            .bind {
                self.drawLoginView(currentState: $0)
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
            view.isHidden = true
        }
        self.titleView.isHidden = false
        self.drawLogin(state: currentState)
        if !currentState {
            self.centerLoginButton.isHidden = false
            self.loginLabel.isHidden = false
        }
        else {
            self.userInfoview.isHidden = false
            self.userRepositoriesList.isHidden = false
            self.userImage.isHidden = false
            self.userName.isHidden = false
        }
    }
    
    func drawLoginButton() {
        self.centerLoginButton.setTitle("로그인", for: .normal)
        self.centerLoginButton.backgroundColor = .systemGray6
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
        self.userName.trailingAnchor.constraint(equalTo: self.userInfoview.trailingAnchor).isActive = true
    }
    
    func drawTitleView() {
        self.titleView.backgroundColor = .systemPink
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
        self.view.addSubview(self.loginLabel)
        self.view.addSubview(centerLoginButton)
        self.view.addSubview(self.titleView)
        self.titleView.addSubview(self.titleLabel)
        self.titleView.addSubview(self.titleLoginButton)
        self.view.addSubview(self.userRepositoriesList)
        self.view.addSubview(userInfoview)
        self.userInfoview.addArrangedSubview(self.userImage)
        self.userInfoview.addArrangedSubview(self.userName)
    }
    
    func drawViews() {
        self.drawLoginButton()
        self.drawLoginLabel()
        self.drawUserinfoView()
        self.drawListTableView()
        self.drawUserInfo()
        self.drawTitleView()
    }
    
    func drawLogin(state: Bool) {
        if !state {
            self.titleLoginButton.setTitle("로그인", for: .normal)
        } else {
            self.titleLoginButton.setTitle("로그아웃", for: .normal)
        }
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
