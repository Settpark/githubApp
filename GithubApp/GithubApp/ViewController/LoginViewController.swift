//
//  LoginViewController.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/05.
//

import UIKit
import RxSwift

final class LoginViewController: UIViewController, ViewModelBindable {
    
    private let disposeBag: DisposeBag
    private let loginButton: UIButton
    var viewModel: LoginViewModel!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.disposeBag = DisposeBag()
        self.loginButton = UIButton()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        self.view.backgroundColor = .white
        self.drawLoginView(currentState: false)
    }
    
    func bindViewModel() {
        initLoginButton()
    }
    
    func initLoginButton() {
        let endpoint = EndPointAuthorization.init()
        self.loginButton.rx.tap
            .bind {
                let url = endpoint.createValidURL(path: .LoginPath, query: nil)
                UIApplication.shared.open(url)
            }.disposed(by: self.disposeBag)
    }
    
    func requestUserRepo(url: URL) {
        let code = url.absoluteString.components(separatedBy: "code=").last ?? ""
        
        self.viewModel.getAceessToken(path: .AccessToken, query: code)
            .subscribe {
            print($0)
        }
    }
}

extension LoginViewController {
    func drawLoginView(currentState: Bool) {
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
        
        let loginLabel = UILabel()
        self.view.addSubview(loginLabel)
        loginLabel.text = "로그인이 필요합니다."
        loginLabel.sizeToFit()
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        loginLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loginLabel.bottomAnchor.constraint(equalTo: self.loginButton.topAnchor, constant: -10).isActive = true
    }
    
    
}