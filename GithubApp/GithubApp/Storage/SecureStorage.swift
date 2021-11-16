//
//  SecureStorage.swift
//  GithubApp
//
//  Created by 박정하 on 2021/11/16.
//

import Foundation

struct SecureStorage {
    func createToken(_ token: AccessTokenModel) {
        guard let data = try? JSONEncoder().encode(token), let _ = token.accessToken else {
            return
        }
        
        let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                kSecAttrAccount: "token",
                                kSecAttrGeneric: data]
        
        SecItemAdd(query as CFDictionary, nil)
    }
    
    func readToken() -> AccessTokenModel? {
        let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                kSecAttrAccount: "token",
                                 kSecMatchLimit: kSecMatchLimitOne,
                           kSecReturnAttributes: true,
                                 kSecReturnData: true]
        
        var item: CFTypeRef?
        if SecItemCopyMatching(query as CFDictionary, &item) != errSecSuccess { return nil }
        
        guard let existingItem = item as? [CFString: Any],
              let data = existingItem[kSecAttrGeneric] as? Data,
              let user = try? JSONDecoder().decode(AccessTokenModel.self, from: data) else { return nil }
        
        return user
    }
    
    func isExistToken() -> Bool {
        let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                kSecAttrAccount: "token",
                                 kSecMatchLimit: kSecMatchLimitOne,
                           kSecReturnAttributes: true,
                                 kSecReturnData: true]
        
        var item: CFTypeRef?
        if SecItemCopyMatching(query as CFDictionary, &item) != errSecSuccess { return false }
        
        guard let existingItem = item as? [CFString: Any],
              let data = existingItem[kSecAttrGeneric] as? Data,
              let _ = try? JSONDecoder().decode(AccessTokenModel.self, from: data) else { return false }
        
        return true
    }
    
    func deleteToken() {
        let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                kSecAttrAccount: "token"]
        SecItemDelete(query as CFDictionary)
    }
}
