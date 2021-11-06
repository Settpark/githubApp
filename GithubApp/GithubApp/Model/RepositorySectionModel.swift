//
//  RepositorySectionModel.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/06.
//

import Foundation
import RxDataSources

struct SectionOfCustomData {
//  var header: String
  var items: [Item]
}

extension SectionOfCustomData: SectionModelType {
  typealias Item = RepositoriesModel

   init(original: SectionOfCustomData, items: [Item]) {
    self = original
    self.items = items
  }
}

