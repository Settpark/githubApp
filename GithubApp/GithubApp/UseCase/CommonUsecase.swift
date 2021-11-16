//
//  CommonUsecase.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/16.
//

import Foundation

class CommonUsecase {
    let repository: RepositoryLayerType
    
    init(repositoryLayer: RepositoryLayerType) {
        self.repository = repositoryLayer
    }
}
