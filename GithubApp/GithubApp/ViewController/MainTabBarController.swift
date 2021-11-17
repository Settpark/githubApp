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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setTabBarItem()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
        self.tabBar.backgroundColor = .darkGray
    }
}
