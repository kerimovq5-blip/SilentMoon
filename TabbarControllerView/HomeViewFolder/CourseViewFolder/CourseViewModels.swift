//
//  CourseViewModels.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 19.08.26.
//

import Foundation
import SilentMoonDomain
import SilentMoonNetwork
@MainActor
enum CourseViewModelsState {
    case idle
    case loading
    case success
    case loaded
    case requestFailed(AppError<ApiErrorEnvelope>)
    
}
@MainActor
final class CourseViewModels {
    
    private var state: CourseViewModelsState = .idle {
        didSet {
            onStateChange?()
        }
    }
    private(set) var coursesList: [CourseEntity] = []
    var onStateChange: (() -> Void)?
    
    private let usecases: CoursesUseCases
    
    init(usecases: CoursesUseCases) {
        self.usecases = usecases
    }
    
    public func fetchCourses (page : Int , limit : Int) {
       
        Task { [weak self] in
            guard let self else { return }
            let result = await self.usecases.getCourses(
                page: page,
                limit: limit
            )
            
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
