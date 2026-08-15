//
//  AppDiContainer.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 13.08.26.
//
import SilentMoonNetwork
import SilentMoonData

final public class AppDiContainer {
    public let networkManager: NetworkManager<ApiErrorEnvelope>
    public let apiService: SilentMoonApiService
    public let tokenStore: TokenStore
    public init (
        networkManager: NetworkManager<ApiErrorEnvelope> ,
        apiService: SilentMoonApiService,
        tokenStore: TokenStore
    ) {
        self.networkManager = networkManager
        self.apiService = apiService
        self.tokenStore = tokenStore
        
    }
  public static func make() -> AppDiContainer {
        let dependencies = NetworkFactory.make()
        return AppDiContainer(
            networkManager: dependencies.networkManager,
            apiService: dependencies.apiService,
            tokenStore: dependencies.tokenStore
        )
    }
}
