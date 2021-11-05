//
//  ViewManager.swift.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/05.
//

import UIKit

protocol ViewDrawManager {
    func drawButton(superView: UIView) -> UIButton
    func drawView(superView: UIView) -> UIView
    func drawTableView(superView: UIView) -> UITableView
    func drawLabel(superView: UIView) -> UILabel
}
    
