//
//  SilentMoonTokenStore.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 30.07.26.
//

//  Access/refresh token-i saxlayır. NetworkManager `requiresAuth == true`
//  olan sorğulara buradakı accessToken-i avtomatik header kimi əlavə edir.
//
//  QEYD: Bu sadə (UserDefaults-a əsaslanan) implementasiyadır.
//  Production-da mütləq Keychain istifadə edin (məsələn, KeychainAccess
//  kitabxanası və ya öz Keychain wrapper-iniz) — token-lər UserDefaults-da
//  şifrələnməmiş şəkildə saxlanılmamalıdır.
//

import Foundation

final class TokenStore {
    static let shared = TokenStore()

    private enum Keys {
        static let accessToken = "silentmoon.accessToken"
        static let refreshToken = "silentmoon.refreshToken"
    }

    private init() {}

    private(set) var accessToken: String? {
        get { UserDefaults.standard.string(forKey: Keys.accessToken) }
        set { UserDefaults.standard.setValue(newValue, forKey: Keys.accessToken) }
    }

    private(set) var refreshToken: String? {
        get { UserDefaults.standard.string(forKey: Keys.refreshToken) }
        set { UserDefaults.standard.setValue(newValue, forKey: Keys.refreshToken) }
    }

    var isLoggedIn: Bool { accessToken != nil }

    func save(access: String, refresh: String) {
        accessToken = access
        refreshToken = refresh
    }

    func clear() {
        accessToken = nil
        refreshToken = nil
    }
}
