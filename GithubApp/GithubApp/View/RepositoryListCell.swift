//
//  UITableViewCell.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/06.
//

import UIKit

final class RepositoryListCell: UITableViewCell {
    
    static var cellidentifier = "cell"
    
    private let icon: UIImageView
    private let starButton: UIButton
    private let entireView: UIStackView
    private var title: String
    private let resultDescription: String
    private let topics: UIStackView
    private let etc: UIStackView
    
    required init?(coder: NSCoder) {
        self.icon = UIImageView()
        self.starButton = UIButton()
        self.entireView = UIStackView()
        self.entireView.axis = .vertical
        self.title = ""
        self.resultDescription = ""
        self.topics = UIStackView()
        self.topics.axis = .horizontal
        self.etc = UIStackView()
        self.etc.axis = .horizontal
        super.init(coder: coder)
    }
    
    func configureText() {
        self.title = "Test"
    }
}
