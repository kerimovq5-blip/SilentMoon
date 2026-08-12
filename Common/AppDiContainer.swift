//
//  AppDiContainer.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 13.08.26.
//
import SilentMoonManagers
import SilentMoonNetworkCommon
import SilentMoonApiService

final class AppDiContainer {
    private let networkManager: NetworkManager<ApiErrorEnvelope>
    private let apiService: SilentMoonApiService
    private let tokenStore: TokenStore
    init (
        networkManager: NetworkManager<ApiErrorEnvelope> ,
        apiService: SilentMoonApiService,
        tokenStore: TokenStore
    ) {
        self.networkManager = networkManager
        self.apiService = apiService
        self.tokenStore = tokenStore
        
    }
    static func make() -> AppDiContainer {
        let dependencies = NetworkFactory.make()
        return AppDiContainer(
            networkManager: dependencies.networkManager,
            apiService: dependencies.apiService,
            tokenStore: dependencies.tokenStore
        )
    }
}
