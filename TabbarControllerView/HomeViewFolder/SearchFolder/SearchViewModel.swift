//
//  SearchViewModel.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 20.08.26.
//

import Foundation
import SilentMoonDomain
import SilentMoonNetwork

@MainActor
enum SearchViewModelState {
    case idle
    case loading
    case loaded
    case empty
    case requestFailed(AppError<ApiErrorEnvelope>)
}

@MainActor
final class SearchViewModel {

    private(set) var state: SearchViewModelState = .idle {
        didSet { onStateChange?() }
    }

    private(set) var results: [CourseSummaryEntity] = [] {
        didSet { onResultsChange?() }
    }

    var onStateChange: (() -> Void)?
    var onResultsChange: (() -> Void)?

    private let usecases: SilentMoonUseCases
    private var currentRequestID = 0
    private var searchDebounceTimer: Timer?

    init(usecases: SilentMoonUseCases) {
        self.usecases = usecases
    }

    func search(query: String) {
        searchDebounceTimer?.invalidate()

        guard query.trimmingCharacters(in: .whitespaces).count >= 2 else {
            currentRequestID += 1
            results = []
            state = .idle
            return
        }

        searchDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { [weak self] _ in
            Task { @MainActor in
                self?.performSearch(query: query)
            }
        }
    }

    private func performSearch(query: String) {
        currentRequestID += 1
        let requestID = currentRequestID
        state = .loading

        Task { [weak self] in
            guard let self else { return }

            let result = await self.usecases.search(
                query: query,
                type: nil,
                page: 1,
                limit: 20
            )

            guard requestID == self.currentRequestID else { return }

            switch result {
            case .success(let response):
                self.results = response.data
                self.state = response.data.isEmpty ? .empty : .loaded
            case .failure(let error):
                self.results = []
                self.state = .requestFailed(self.asAppError(error))
            }
        }
    }

    private func asAppError(_ error: Error) -> AppError<ApiErrorEnvelope> {
        (error as? AppError<ApiErrorEnvelope>) ?? .unknown(error)
    }
}
