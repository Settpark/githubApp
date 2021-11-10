//
//  UITableViewCell.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/06.
//

import UIKit
import RxSwift

final class RepositoryListCell: UITableViewCell {
    
    static var cellIdentifier = "cell"
    
    private let disposeBag: DisposeBag
    private let customContentView: UIStackView
    private let topics: UIStackView
    private let etc: UIStackView
    private let icon: UIImageView
    private var title: UIStackView
    private let customDescription: UILabel
    private let starButton: UIButton
    private weak var delegate: StarManager?
    private var isCheck: Bool?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.disposeBag = DisposeBag()
        
        self.customContentView = UIStackView()
        self.customContentView.axis = .vertical
        self.customContentView.distribution = .equalSpacing
        self.customContentView.alignment = .top
        self.customContentView.spacing = 5
        
        self.topics = UIStackView()
        self.topics.axis = .horizontal
        self.topics.distribution = .fill
        self.topics.alignment = .leading
        self.topics.spacing = 5
        self.title = UIStackView()
        self.title.axis = .horizontal
        self.title.alignment = .leading
        self.title.spacing = 0
        self.etc = UIStackView()
        self.etc.axis = .horizontal
        self.etc.distribution = .equalSpacing
        self.etc.alignment = .leading
        
        self.icon = UIImageView()
        self.starButton = UIButton()
        self.customDescription = UILabel()
        self.customDescription.numberOfLines = 2
        self.isCheck = nil
        super.init(style: .default, reuseIdentifier: nil)
    }
    
    required init?(coder: NSCoder) {
        self.disposeBag = DisposeBag()
        
        self.customContentView = UIStackView()
        self.customContentView.axis = .vertical
        self.topics = UIStackView()
        self.topics.axis = .horizontal
        self.etc = UIStackView()
        self.etc.axis = .horizontal
        self.etc.distribution = .equalSpacing
        self.etc.alignment = .leading
        
        self.icon = UIImageView()
        self.starButton = UIButton()
        self.title = UIStackView()
        self.customDescription = UILabel()
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.starButton.setBackgroundImage(nil, for: .normal)
        self.title.subviews.forEach { view in
            view.removeFromSuperview()
        }
        self.topics.subviews.forEach { view in
            view.removeFromSuperview()
        }
        self.etc.subviews.forEach { view in
            view.removeFromSuperview()
        }
        self.constraints.forEach { constraint in
            removeConstraint(constraint)
        }
    }
    
    func configureCell(with source: RepositoriesModel, buttonDelegate: StarManager) {
        self.delegate = buttonDelegate
        self.drawIcon()
        self.configureContentView()
        self.drawTitle(source1: source.owner?.login, source2: source.name)
        self.drawDescription(source: source.description)
        self.drawTopics(source: source.topics)
        self.drawStarCount(source: source.stargazersCount)
        self.drawStarButton(constraint: self)
        
        initIsCheck(owner: source.owner, name: source.name)
    }
    
    func initIsCheck(owner: Owner?, name: String?) {
        guard let ownerInfo = owner?.login, let repoName = name else {
            return
        }
        self.delegate?.checkStarRepository(owner: ownerInfo, repo: repoName)
            .observe(on: MainScheduler.instance)
            .bind() { [weak self] check in
                self?.initStarImage(owner: ownerInfo, repo: repoName, ischeck: check)
                self?.bindStarButton(owner: ownerInfo, repo: repoName)
            }.disposed(by: self.disposeBag)
    }
    
    func initStarImage(owner: String, repo: String, ischeck: Bool?) {
        if !(ischeck ?? false) {
            self.starButton.setBackgroundImage(UIImage(systemName: "star"), for: .normal)
        } else {
            self.starButton.setBackgroundImage(UIImage(systemName: "star.fill"), for: .normal)
        }
    }
    
    func bindStarButton(owner: String, repo: String) {
        self.starButton.rx.tap
            .bind { [unowned self] _ in
                self.delegate?.checkStarRepository(owner: owner, repo: repo)
                    .observe(on: MainScheduler.instance)
                    .bind { [weak self] check in
                        if check == nil {
                            return
                        }
                        else if !(check!)  {
                            self?.delegate?.starRepository(owner: owner, repo: repo)
                            self?.starButton.setBackgroundImage(UIImage(systemName: "star.fill"), for: .normal)
                        }
                        else {
                            self?.delegate?.unstarRespository(owner: owner, repo: repo)
                            self?.starButton.setBackgroundImage(UIImage(systemName: "star"), for: .normal)
                        }
                    }.disposed(by: self.disposeBag)
            }.disposed(by: self.disposeBag)
    }
    
    func drawIcon() {
        self.addSubview(self.icon)
        self.icon.translatesAutoresizingMaskIntoConstraints = false
        self.icon.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.05).isActive = true
        self.icon.heightAnchor.constraint(equalTo: self.icon.widthAnchor).isActive = true
        self.icon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        let basicConstraint = self.icon.topAnchor.constraint(equalTo: self.topAnchor, constant: 25)
        basicConstraint.priority = .defaultLow
        basicConstraint.isActive = true
        self.icon.image = UIImage(systemName: "text.book.closed")
    }
    
    func configureContentView() {
        self.addSubview(customContentView)
        self.customContentView.translatesAutoresizingMaskIntoConstraints = false
        self.customContentView.leadingAnchor.constraint(equalTo: self.icon.trailingAnchor, constant: 10).isActive = true
        let basicTopAnchor = self.customContentView.topAnchor.constraint(equalTo: self.topAnchor, constant: 25)
        basicTopAnchor.priority = .defaultLow
        basicTopAnchor.isActive = true
    }
    
    func drawTitle(source1 user: String?, source2 name: String?) {
        guard let existUser = user, let existName = name else {
            return
        }
        self.customContentView.addArrangedSubview(self.title)
        self.title.translatesAutoresizingMaskIntoConstraints = false
        let userLabel = UILabel()
        userLabel.text = existUser + "/"
        userLabel.font = .systemFont(ofSize: 14)
        userLabel.sizeToFit()
        userLabel.textAlignment = .left
        self.title.addArrangedSubview(userLabel)
        let nameLabel = UILabel()
        nameLabel.text = existName
        nameLabel.font = .boldSystemFont(ofSize: 14)
        nameLabel.sizeToFit()
        userLabel.textAlignment = .left
        self.title.addArrangedSubview(nameLabel)
    }
    
    func drawDescription(source: String?) {
        guard let des = source else {
            return
        }
        self.customContentView.addArrangedSubview(self.customDescription)
        self.customDescription.text = des
        self.customDescription.font = .systemFont(ofSize: 14)
        self.customDescription.sizeToFit()
        self.customDescription.textAlignment = .left
    }
    
    func drawTopics(source: [String]?) {
        if let topics = source {
            self.topics.translatesAutoresizingMaskIntoConstraints = false
            self.customContentView.addArrangedSubview(self.topics)
            for item in topics {
                let label = UILabel()
                label.backgroundColor = .systemPink
                label.tintColor = .white
                label.text = item
                label.sizeToFit()
                label.font = .systemFont(ofSize: 14)
                self.topics.addArrangedSubview(label)
            }
        }
    }
    
    func drawStarCount(source: Int?) {
        guard let localStar = source else {
            return
        }
        self.customContentView.addArrangedSubview(self.etc)
        let starView = UIStackView()
        starView.axis = .horizontal
        starView.spacing = 5
        let starImage = UIImageView(image: UIImage(systemName: "star.fill"))
        starView.addArrangedSubview(starImage)
        let starCount = UILabel()
        starView.addArrangedSubview(starCount)
        self.etc.addArrangedSubview(starView)
        starCount.font = .systemFont(ofSize: 13)
        if localStar >= 1000 {
            let result = Float(localStar / 1000)
            starCount.text = "\(result)k"
        } else {
            starCount.text = "\(localStar)"
        }
        starImage.tintColor = .systemPink
        starImage.translatesAutoresizingMaskIntoConstraints = false
        starImage.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.05).isActive = true
        starImage.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.05).isActive = true
    }
    
    func drawStarButton(constraint guide: UIView) {
        self.addSubview(starButton)
        self.bringSubviewToFront(self.starButton)
        self.starButton.tintColor = .systemPink
        self.starButton.setBackgroundImage(UIImage(systemName: "star"), for: .normal)
        self.starButton.translatesAutoresizingMaskIntoConstraints = false
        self.starButton.widthAnchor.constraint(equalTo: guide.widthAnchor, multiplier: 0.1).isActive = true
        self.starButton.heightAnchor.constraint(equalTo: guide.widthAnchor, multiplier: 0.1).isActive = true
        self.starButton.topAnchor.constraint(equalTo: guide.topAnchor, constant: 10).isActive = true
        self.starButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -20).isActive = true
        
        self.customContentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        let contentViewFinalConstraint = self.customContentView.topAnchor.constraint(equalTo: self.starButton.bottomAnchor, constant: 10)
        contentViewFinalConstraint.priority = .defaultHigh
        let iconFinalConstraint = self.icon.topAnchor.constraint(equalTo: self.starButton.bottomAnchor, constant: 10)
        iconFinalConstraint.priority = .defaultHigh
        layoutIfNeeded()
        
        if self.customContentView.frame.origin.x + self.title.frame.width > self.starButton.frame.origin.x {
            contentViewFinalConstraint.isActive = true
            iconFinalConstraint.isActive = true
        }
        
    }
}
