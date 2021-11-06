//
//  UITableViewCell.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/06.
//

import UIKit

final class RepositoryListCell: UITableViewCell {
    
    static var cellIdentifier = "cell"
    
    private let icon: UIImageView
    private let starButton: UIButton
    private let entireView: UIStackView
    private var title: UILabel
    private let resultDescription: UILabel
    private let topics: UIStackView
    private let etc: UIStackView
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        self.icon = UIImageView()
        self.starButton = UIButton()
        self.entireView = UIStackView()
        self.entireView.axis = .vertical
        self.title = UILabel()
        self.resultDescription = UILabel()
        self.topics = UIStackView()
        self.topics.axis = .horizontal
        self.etc = UIStackView()
        self.etc.axis = .horizontal
        super.init(style: .default, reuseIdentifier: nil)
    }
    
    required init?(coder: NSCoder) {
        self.icon = UIImageView()
        self.starButton = UIButton()
        self.entireView = UIStackView()
        self.entireView.axis = .vertical
        self.title = UILabel()
        self.resultDescription = UILabel()
        self.topics = UIStackView()
        self.topics.axis = .horizontal
        self.etc = UIStackView()
        self.etc.axis = .horizontal
        super.init(coder: coder)
    }
    
    func configureText() {
        self.title.text = "Test"
        self.title.font = .systemFont(ofSize: 20)
        self.addSubview(title)
        self.title.sizeToFit()
        self.title.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.title.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}
