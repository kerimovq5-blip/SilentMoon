//
//  ReminderModelsState.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 14.08.26.
//

import Foundation
import SilentMoonNetwork
import SilentMoonDomain

@MainActor
enum ReminderModelsState {
    case idle
    case loading
    case success
    case deleted
    case invalidInput(String)
    case requestFailed(AppError<ApiErrorEnvelope>)
}

@MainActor
final class ReminderStateModels {
    
    private(set) var state: ReminderModelsState = .idle {
        didSet {
            onStateChange?()
        }
    }
    
    var onStateChange: (() -> Void)?
    
    var selectedDate: Date = Date()
    var selectedDays: Set<Int> = []
    var reminderMessage: String = ""
    private(set) var currentReminder: ReminderResponseEntity?
    
    private let repository: SilentMoonRepository
    
    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    init(repository: SilentMoonRepository) {
        self.repository = repository
    }
    
    func toggleDays(_ day: Int) {
        if selectedDays.contains(day) {
            selectedDays.remove(day)
        } else {
            selectedDays.insert(day)
        }
    }

    func loadReminders() {
        state = .loading

        Task { [weak self] in
            guard let self else { return }

            let result = await self.repository.getReminders()

            switch result {
            case .success(let reminders):
                self.currentReminder = reminders.first
                self.state = .success
            case .failure(let error):
                self.state = .requestFailed(self.asAppError(error))
            }
        }
    }
    
    func saveReminder() {
        guard !selectedDays.isEmpty else {
            state = .invalidInput("Please select at least one day")
            return
        }
        
        state = .loading
        
        Task { [weak self] in
            guard let self else { return }

            let formattedTime = Self.timeFormatter.string(from: self.selectedDate)

            let result = await self.repository.setReminder(
                time: formattedTime,
                days: Array(self.selectedDays),
                message: self.reminderMessage
            )

            switch result {
            case .success(let reminder):
                self.currentReminder = reminder
                self.state = .success
            case .failure(let error):
                self.state = .requestFailed(self.asAppError(error))
            }
        }
    }

    func updateReminder() {
        guard let id = currentReminder?.id else {
            state = .invalidInput("Yenilənəcək bir xatırlatma tapılmadı.")
            return
        }
        guard !selectedDays.isEmpty else {
            state = .invalidInput("Please select at least one day")
            return
        }

        state = .loading

        Task { [weak self] in
            guard let self else { return }

            let formattedTime = Self.timeFormatter.string(from: self.selectedDate)

            let result = await self.repository.updateReminder(
                id: id,
                time: formattedTime,
                days: Array(self.selectedDays),
                message: self.reminderMessage
            )

            switch result {
            case .success(let reminder):
                self.currentReminder = reminder
                self.state = .success
            case .failure(let error):
                self.state = .requestFailed(self.asAppError(error))
            }
        }
    }

    func deleteReminder() {
        guard let id = currentReminder?.id else {
            state = .invalidInput("Silinəcək bir xatırlatma tapılmadı.")
            return
        }

        state = .loading

        Task { [weak self] in
            guard let self else { return }

            let result = await self.repository.deleteReminder(id: id)

            switch result {
            case .success:
                self.currentReminder = nil
                self.state = .deleted
            case .failure(let error):
                self.state = .requestFailed(self.asAppError(error))
            }
        }
    }
    
    private func asAppError(_ error: Error) -> AppError<ApiErrorEnvelope> {
        (error as? AppError<ApiErrorEnvelope>) ?? .unknown(error)
    }
}
