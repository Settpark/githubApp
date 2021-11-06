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
    
    private let disposeBag: DisposeBag
    private var listDataSource: RxTableViewSectionedReloadDataSource<SectionOfCustomData>!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.disposeBag = DisposeBag()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.disposeBag = DisposeBag()
        super.init(coder: coder)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.backgroundColor = .white
        drawViewElement()
    }
    
    func drawViewElement() {
        let titleView = drawTopview()
        let searchField = drawTextField(constraint: titleView)
        drawSearchbutton(constraint: searchField)
        let tableView = drawTableView(constraint: searchField)
    }
    
    func drawButton(superView: UIView) -> UIButton {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.rx.tap.bind { _ in
            print("로그인 버튼 기능")
        }.disposed(by: disposeBag)
        return button
    }
    
    func drawSearchbutton(constraint guide: UIView) -> Void {
        let searchButton = UIButton.init(frame: CGRect(origin: .zero, size: .zero))
        self.view.addSubview(searchButton)
        searchButton.setImage(UIImage(systemName: "magnifyingglass.circle"), for: .normal)
        searchButton.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        searchButton.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
        searchButton.layer.masksToBounds = false
        searchButton.layer.cornerRadius = 0.3
        
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        searchButton.centerYAnchor.constraint(equalTo: guide.centerYAnchor).isActive = true
        searchButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: ViewRatio.searchButtonWidth.rawValue).isActive = true
        searchButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: ViewRatio.textFieldHeightRatio.rawValue).isActive = true
    }
    
    func drawTopview() -> UIView {
        let topView = UIView(frame: CGRect(x: self.view.safeAreaInsets.left, y: self.view.safeAreaInsets.top, width: self.view.frame.width, height: self.view.frame.height / ViewRatio.topViewHeightRatio.rawValue))
        topView.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
        self.view.addSubview(topView)
        
        let titleView = drawLabel(constraint: topView)
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
    
    func drawTableView(constraint guide: UIView) -> UITableView {
        let tableView = UITableView.init(frame: CGRect(origin: .zero, size: .zero))
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        tableView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        return tableView
    }
    
    func drawLabel(constraint guide: UIView) -> UILabel {
        let title = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: guide.frame.width / ViewRatio.titleWidthRatio.rawValue, height: guide.frame.height)))
        title.text = "Github"
        title.font = .systemFont(ofSize: 17)
        return title
    }
    
    func drawTextField(constraint guide: UIView) -> UITextField {
        let textField = UITextField.init(frame: CGRect(origin: .zero, size: .zero))
        self.view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 10).isActive = true
        textField.topAnchor.constraint(equalTo: guide.bottomAnchor, constant: 10).isActive = true
        textField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: ViewRatio.textFieldWidthRatio.rawValue).isActive = true
        textField.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: ViewRatio.textFieldHeightRatio.rawValue).isActive = true
        textField.borderStyle = .roundedRect
        
        return textField
    }
}

extension RepositoryListViewController {
    private func initDataSource() {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfCustomData>(
            configureCell: { dataSource, tableView, indexPath, item in
                guard let cell: RepositoryListCell = tableView.dequeueReusableCell(withIdentifier: RepositoryListCell.cellidentifier, for: indexPath) as? RepositoryListCell else {
                    return UITableViewCell()
                }
                cell.configureText()
                return cell
            })
    }
}
