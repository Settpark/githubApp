//
//  ViewController.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/04.
//

import UIKit
import RxSwift
import RxDataSources

final class RepositoryListViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.backgroundColor = .white
        drawViewElement()
    }
    
    func drawViewElement() {
        let topView = drawTopview()
        let tableView = drawTableView(guide: topView)
    }
    
    func drawButton(superView: UIView) -> UIButton {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.rx.tap.bind { _ in
            print("로그인 버튼 기능")
        }.disposed(by: disposeBag)
        return button
    }
    
    func drawTopview() -> UIView {
        let topView = UIView(frame: CGRect(x: self.view.safeAreaInsets.left, y: self.view.safeAreaInsets.top, width: self.view.frame.width, height: self.view.frame.height / ViewRatio.topViewHeightRatio.rawValue))
        topView.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
        self.view.addSubview(topView)
        
        let titleView = drawLabel(superView: topView)
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
    
    func drawTableView(guide: UIView) -> UITableView {
        let tableView = UITableView.init(frame: CGRect(origin: .zero, size: .zero))
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        tableView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        return tableView
    }
    
    func drawLabel(superView: UIView) -> UILabel {
        let title = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: superView.frame.width / ViewRatio.titleWidthRatio.rawValue, height: superView.frame.height)))
        title.text = "Github"
        title.font = .systemFont(ofSize: 17)
        return title
    }
}

