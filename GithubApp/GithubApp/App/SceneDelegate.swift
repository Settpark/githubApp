//
//  SceneDelegate.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/04.
//

import UIKit
import RxSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let apiService = APIService(urlSessionManager: URLSession.shared.rx)
        let repositoryLayer = RepositoryLayer(apiService: apiService, authentication: AuthenticationManager(), secureStorage: SecureStorage())
        let searchUsecase = SearchRepositoriesUsecase(repositoryLayer: repositoryLayer)
        let repositoriesViewModel = RepositoryListViewModel(usecaseLayer: searchUsecase)
        let loginUsecase = LoginUsecase(repositoryLayer: repositoryLayer)
        let loginViewModel = LoginViewModel(usecase: loginUsecase)
        let loginViewController = Scene.LoginView(loginViewModel).instantiate()
        let firstViewController = Scene.Repositories(repositoriesViewModel, loginViewController as! LoginDelegate).instantiate()
        
        let rootVC = MainTabBarController()
        rootVC.setViewControllers([firstViewController, loginViewController], animated: true)
        
        window = UIWindow(windowScene: windowScene)
        window?.windowScene = windowScene
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
    }
    
    
}

