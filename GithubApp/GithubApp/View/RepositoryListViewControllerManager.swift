//
//  MainViewControllerManager.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/05.
//

import UIKit
import RxSwift

struct RepositoryListViewControllerManager: ViewDrawManager {
    
    let disposeBag = DisposeBag()
    
    func drawButton(superView: UIView) -> UIButton {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.rx.tap.bind { _ in
            print("로그인 버튼 기능")
        }.disposed(by: disposeBag)
        return button
    }
    
    func drawView(superView: UIView) -> UIView {
        let topView = UIView(frame: CGRect(x: superView.safeAreaInsets.left, y: superView.safeAreaInsets.top, width: superView.frame.width, height: superView.frame.height / ViewRatio.topViewHeightRatio.rawValue))
        topView.backgroundColor = .systemPink
        
        let titleView = drawButton(superView: topView)
        topView.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
        titleView.centerYAnchor.constraint(equalTo: topView.centerYAnchor).isActive = true
        
        let button = drawButton(superView: topView)
        topView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerYAnchor.constraint(equalTo: topView.centerYAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: ViewRatio.buttonTrailingAnchor.rawValue).isActive = true
        
        return topView
    }
    
    func drawTableView(superView: UIView) -> UITableView {
        let tableView = UITableView.init(frame: CGRect(origin: .zero, size: .zero))
        superView.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.widthAnchor.constraint(equalTo: superView.widthAnchor).isActive = true
        tableView.heightAnchor.constraint(equalTo: superView.heightAnchor).isActive = true
        return tableView
    }
    
    func drawLabel(superView: UIView) -> UILabel {
        let title = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: superView.frame.width / ViewRatio.titleWidthRatio.rawValue, height: superView.frame.height)))
        
        title.text = "Github"
        title.font = .systemFont(ofSize: 20)
        return title
    }
}


enum ViewRatio: CGFloat {
    case topViewHeightRatio = 16
    case titleWidthRatio = 5
    case buttonWidthRatio = 6
    case buttonTrailingAnchor = -10
}
