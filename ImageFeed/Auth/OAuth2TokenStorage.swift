//
//  OAuth2TokenStorage.swift
//  ImageFeed
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    private enum Keys: String {
        case token = "com.imagefeed.authkey"
    }

    static let shared = OAuth2TokenStorage()
    private let keychain = KeychainWrapper.standard

    private init() {}

    var token: String? {
        get {
            keychain.string(forKey: Keys.token.rawValue)
        }
        set {
            guard let newValue else { return }
            keychain.set(newValue, forKey: Keys.token.rawValue)
        }
    }

    func removeToken() {
        keychain.removeObject(forKey: Keys.token.rawValue)
    }
}
