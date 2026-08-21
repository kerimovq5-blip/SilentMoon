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
    public let usecases: SilentMoonUseCases
    public let tokenStore: TokenStore

    public init(
        networkManager: NetworkManager<ApiErrorEnvelope>,
        repository: SilentMoonRepository,
        usecases: SilentMoonUseCases,
        tokenStore: TokenStore
    ) {
        self.networkManager = networkManager
        self.repository = repository
        self.usecases = usecases
        self.tokenStore = tokenStore
    }

    public static func make() -> AppDiContainer {
        let dependencies = NetworkFactory.make()
        let usecases = UseCasesImplemantation(repository: dependencies.apiService)
        return AppDiContainer(
            networkManager: dependencies.networkManager,
            repository: dependencies.apiService ,
            usecases: usecases,
            tokenStore: dependencies.tokenStore
        )
    }
    
}
