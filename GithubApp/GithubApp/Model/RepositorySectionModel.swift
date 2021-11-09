//
//  RepositorySectionModel.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/06.
//

import Foundation
import RxDataSources

struct RepositoryListSectionData {
  var items: [Item]
}

extension RepositoryListSectionData: SectionModelType {
  typealias Item = RepositoriesModel

   init(original: RepositoryListSectionData, items: [Item]) {
    self = original
    self.items = items
  }
}

