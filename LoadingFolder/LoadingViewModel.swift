//
//  LoadingViewModel.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 19.08.26.
//

import Foundation
import SilentMoonNetwork

enum LoadingViewModelState {
    case idle
    case loading
    case loaded
    case requestFailed(AppError<ApiErrorEnvelope>)
}

@MainActor
final class LoadingViewModel {

    private(set) var state: LoadingViewModelState = .idle {
        didSet { onStateChange?() }
    }

    var onStateChange: (() -> Void)?
    var onError: ((AppError<ApiErrorEnvelope>) -> Bool)?

    private let action: () async -> Result<Void, Error>
    private var loadTask: Task<Void, Never>?

    init(action: @escaping () async -> Result<Void, Error>) {
        self.action = action
    }

    func load() {
        loadTask?.cancel()
        state = .loading
        loadTask = Task { [weak self] in
            guard let self else { return }
            let result = await self.action()
            guard !Task.isCancelled else { return }
            switch result {
            case .success:
                self.state = .loaded
            case .failure(let error):
                let appError = self.asAppError(error)
                if self.onError?(appError) == true {
                    self.state = .idle
                } else {
                    self.state = .requestFailed(appError)
                }
            }
        }
    }

    private func asAppError(_ error: Error) -> AppError<ApiErrorEnvelope> {
        (error as? AppError<ApiErrorEnvelope>) ?? .unknown(error)
    }
}
