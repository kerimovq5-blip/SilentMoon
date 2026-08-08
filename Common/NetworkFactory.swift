//
//  NetworkFactory.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 08.08.26.
//

import Foundation
import SilentMoonNetworkCommon
import SilentMoonManager

struct NetworkFactory {
    static func make() -> (tokenStore: TokenStore, apiService: SilentMoonApiService) {

        let tokenStore = TokenStore(
            keys: TokenKeys(
                accessToken: "silentmoon.accessToken",
                refreshToken: "silentmoon.refreshToken"
            )
        )
        let networkManager = NetworkManager(
            session: URLSession.shared,
            mainPath: "http://13.48.242.142:30080/api/v1",
            header: [
                "accept": "application/json",
                "content-type": "application/json"
            ],
            errorDecoder: { data in
                try? JSONDecoder().decode(ApiErrorEnvelope.self, from: data)
            },
            tokenStore: tokenStore
        )

        let apiService = SilentMoonApiService(
            networkManager: networkManager,
            tokenStore: tokenStore
        )

        return (tokenStore, apiService)
    }
}
