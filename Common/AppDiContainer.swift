//
//  AppDiContainer.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 13.08.26.
//
import SilentMoonNetwork
import SilentMoonDomain
import SilentMoonData

final public class AppDiContainer {
    public let networkManager: NetworkManager<ApiErrorEnvelope>
    public let repository: SilentMoonRepository
    public let tokenStore: TokenStore
    public init (
        networkManager: NetworkManager<ApiErrorEnvelope> ,
        repository: SilentMoonRepository,
        tokenStore: TokenStore
    ) {
        self.networkManager = networkManager
        self.repository = repository
        self.tokenStore = tokenStore
        
    }
  public static func make() -> AppDiContainer {
        let dependencies = NetworkFactory.make()
        return AppDiContainer(
            networkManager: dependencies.networkManager,
            repository: dependencies.repository,
            tokenStore: dependencies.tokenStore
        )
    }
}
