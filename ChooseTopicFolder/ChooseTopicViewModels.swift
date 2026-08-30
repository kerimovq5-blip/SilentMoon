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

@MainActor
final class ChooseTopicViewModel {
    
    private(set) var state: ChooseTopicViewModelState = .idle {
        didSet {
            onStateChange?()
        }
    }
    
    var onStateChange: (() -> Void)?
    
    private let usecases: TopicsUseCases
    
    init(usecases: TopicsUseCases) {
        self.usecases = usecases
    }
    
    func choose(topicIds: [Int]) {
        
        guard !topicIds.isEmpty else {
            state = .invalidInput(AppStrings.emptyTopicSelectionError.letters)
            return
        }
        state = .loading
        Task {
            let result = await usecases.updateTopics(topicIds: topicIds)
            handleChooseTopic(result: result)
        }
    }
    
    private func handleChooseTopic(result: Result<[ChooseTopicEntity], any Error>) {
        switch result {
        case .success:
            self.state = .success
        case .failure(let error):
            let appError = self.asAppError(error)
            self.state = .requestFailed(appError)
        }
    }
    
    private func asAppError(_ error: Error) -> AppError<ApiErrorEnvelope> {
        (error as? AppError<ApiErrorEnvelope>) ?? .unknown(error)
    }
}
