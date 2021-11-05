//
//  UITabbarController.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/05.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setTabBarItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    func setTabBarItem() -> Void {
        let tabOneBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass.circle"), selectedImage: UIImage(systemName: "magnifyingglass.circle.fill"))
        let firstViewController = self.viewControllers?.first
        firstViewController?.tabBarItem = tabOneBarItem
        
        let tabTwoBarItem2 = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        let secondViewController = self.viewControllers?[1]
        secondViewController?.tabBarItem = tabTwoBarItem2
    }
}
