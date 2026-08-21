//
//  CourseDetailViewModel.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 19.08.26.
//

import Foundation
import SilentMoonDomain
import SilentMoonNetwork

@MainActor
enum CourseDetailViewModelState {
    case idle
    case loading
    case loaded
    case requestFailed(AppError<ApiErrorEnvelope>)
}

@MainActor
final class CourseDetailViewModel {
    
    private(set) var state: CourseDetailViewModelState = .idle {
        didSet {
            onStateChange?()
        }
    }
    
    private(set) var selectedCourseDetail: CourseEntity?
    var onStateChange: (() -> Void)?
    
    private let repository: SilentMoonRepository
    
    init(repository: SilentMoonRepository) {
        self.repository = repository
    }
    
    public func fetchCourseDetail(id: Int) {
        state = .loading
        
        Task { [weak self] in
            guard let self else { return }
            
            let result = await self.repository.getCourseDetail(id: id)
            
            switch result {
            case .success(let courseDetail):
                self.selectedCourseDetail = courseDetail
                self.state = .loaded
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
