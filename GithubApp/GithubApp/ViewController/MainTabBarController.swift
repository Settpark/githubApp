//
//  UITabbarController.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/05.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    private let titleView: UIView
    private let loginButton: UIButton
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.titleView = UIView()
        self.loginButton = UIButton()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.titleView = UILabel()
        self.loginButton = UIButton()
        super.init(coder: coder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setTabBarItem()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        drawTopview(constraint: self.view)
    }
    
    func sendAccessCode(url: URL) {
        guard let loginViewController = self.viewControllers?[1] as? LoginViewController else {
            return
        }
        loginViewController.requestUserRepo(url: url)
    }
}

extension MainTabBarController {
    func setTabBarItem() -> Void {
        let tabOneBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass.circle"), selectedImage: UIImage(systemName: "magnifyingglass.circle.fill"))
        let firstViewController = self.viewControllers?.first
        firstViewController?.tabBarItem = tabOneBarItem
        
        let tabTwoBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        let secondViewController = self.viewControllers?[1]
        secondViewController?.tabBarItem = tabTwoBarItem
        
        self.tabBar.unselectedItemTintColor = .white
        self.tabBar.tintColor = .white
        self.tabBar.backgroundColor = .systemPink
    }
    
    func drawTopview(constraint guide: UIView) {
        self.view.addSubview(self.titleView)
        self.titleView.backgroundColor = .systemPink
        self.titleView.translatesAutoresizingMaskIntoConstraints = false
        self.titleView.centerXAnchor.constraint(equalTo: guide.safeAreaLayoutGuide.centerXAnchor).isActive = true
        self.titleView.topAnchor.constraint(equalTo: guide.safeAreaLayoutGuide.topAnchor).isActive = true
        self.titleView.widthAnchor.constraint(equalTo: guide.safeAreaLayoutGuide.widthAnchor).isActive = true
        self.titleView.heightAnchor.constraint(equalTo: guide.safeAreaLayoutGuide.heightAnchor, multiplier: ViewRatio.topViewHeightRatio.rawValue).isActive = true
        self.drawTitleview(constraint: self.titleView)
        self.drawLoginview(constraint: titleView)
    }
    
    func drawTitleview(constraint guide: UIView) {
        let titleLabel = UILabel()
        guide.addSubview(titleLabel)
        titleLabel.text = "Github"
        titleLabel.font = .systemFont(ofSize: 17)
        titleLabel.sizeToFit()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: guide.centerYAnchor).isActive = true
    }
    
    func drawLoginview(constraint guide: UIView) {
        guide.addSubview(self.loginButton)
        self.loginButton.setTitle("로그인", for: .normal)
        self.loginButton.sizeToFit()
        self.loginButton.translatesAutoresizingMaskIntoConstraints = false
        self.loginButton.centerYAnchor.constraint(equalTo: guide.centerYAnchor).isActive = true
        self.loginButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -10).isActive = true
    }
    
    func drawRepositoryListSearchBar() {
        guard let firstViewController = self.selectedViewController as? RepositoryListViewController else {
            return
        }
        firstViewController.drawSearchfield(constraint: self.titleView)
    }
}
