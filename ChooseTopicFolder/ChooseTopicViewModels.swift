import Foundation
import SilentMoonDomain
import SilentMoonNetwork

@MainActor
enum ChooseTopicViewModelState {
    case idle
    case loading
    case success
    case invalidInput(String)
    case requestFailed(AppError<ApiErrorEnvelope>)
}

final class ChooseTopicViewModel {
    
    private(set) var state: ChooseTopicViewModelState = .idle {
        didSet {
            onStateChange?()
        }
    }
    
    var onStateChange: (() -> Void)?
    
    private let service: SilentMoonRepository
    
    init(service: SilentMoonRepository) {
        self.service = service
    }
    
    func choose(topicIds: [String]) {
        
        guard !topicIds.isEmpty else {
            state = .invalidInput("Please select at least one topic.")
            return
        }
        state = .loading
        Task {  [weak self] in
            guard let self else { return }
            let result = await self.service.updateTopics(
                topicIds: topicIds)
            switch result {
            case .success:
                self.state = .success
            case .failure(let error):
                let appError = self.asAppError(error)
                self.state = .requestFailed(appError)
            }
        }
    }
    
    private func asAppError(_ error: Error) -> AppError<ApiErrorEnvelope> {
        (error as? AppError<ApiErrorEnvelope>) ?? .unknown(error)
    }
}
