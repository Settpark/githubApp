//
//  Scene.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/08.
//

import UIKit

enum Scene {
    case Repositories(RepositoryListViewModel)
    case LoginView(LoginViewModel)
}

extension Scene {
    func instantiate(from Storyboard: String = "Main") -> UIViewController {
        switch self {
        case .Repositories(let viewModel):
            var repositoriesViewController = RepositoryListViewController()
            repositoriesViewController.bind(viewModel: viewModel)
            return repositoriesViewController
        case .LoginView(let viewModel):
            var LoginVC = LoginViewController()
            LoginVC.bind(viewModel: viewModel)
            return LoginVC
        }
    }
}
