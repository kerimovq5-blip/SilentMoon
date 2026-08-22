////
////  MusicListViewModel.swift
////  SilentMoon
////
////  Created by Kerimov Qehreman on 22.08.26.
////
//
//import UIKit
//import SilentMoonDomain
//import SilentMoonNetwork
//
//enum MusicListViewModelState {
//    case idle
//    case loading
//    case loaded
//    case requestFailed(AppError<ApiErrorEnvelope>)
//}
//
//@MainActor
//public final class MusicListViewModel {
//
//    
//    private(set) var items: [CourseEntity] = []
//
//    private(set) var state: MusicListViewModelState = .idle {
//        didSet { onStateChange?() }
//    }
//    var onStateChange: (() -> Void)?
//
//    private let repository: SilentMoonRepository
//    private var loadTask: Task<Void, Never>?
//
//    public init(repository: SilentMoonRepository) {
//        self.repository = repository
//    }
//
//    func loadCourses() {
//        loadTask?.cancel()
//        state = .loading
//        loadTask = Task { [weak self] in
//            guard let self else { return }
//            
//            let result = await self.repository.getCourses(page: 1, limit: 50)
//            guard !Task.isCancelled else { return }
//            switch result {
//            case .success(let response):
//                
//                self.items = response.courses
//                self.state = .loaded
//            case .failure(let error):
//                self.items = []
//                self.state = .requestFailed(self.asAppError(error))
//            }
//        }
//    }
//
//    private func asAppError(_ error: Error) -> AppError<ApiErrorEnvelope> {
//        (error as? AppError<ApiErrorEnvelope>) ?? .unknown(error)
//    }
//}
