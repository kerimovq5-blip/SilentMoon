import Foundation
import SilentMoonNetwork
import SilentMoonDomain

@MainActor
enum ReminderViewModelsState {
    case idle
    case loading
    case success
    case deleted
    case invalidInput(String)
    case requestFailed(AppError<ApiErrorEnvelope>)
}

@MainActor
final class ReminderViewModels {
    
    private(set) var state: ReminderViewModelsState = .idle {
        didSet { onStateChange?() }
    }
    
    var onStateChange: (() -> Void)?
    
    var selectedDate: Date = Date()
    var selectedDays: Set<Int> = []
    var reminderMessage: String = ""
    private(set) var currentReminder: ReminderResponseEntity?
    
    private let usecases: ReminderUseCases
    
    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    init(usecases: ReminderUseCases) {
        self.usecases = usecases
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
            let result = await self.usecases.getReminders()
            self.handleLoadReminderResult(result)
        }
    }
    
    func saveReminder() {
        guard validateInput() else { return }
        state = .loading
        Task { [weak self] in
            guard let self else { return }
            let formattedTime = Self.timeFormatter.string(from: self.selectedDate)
            let result = await self.usecases.setReminder(
                time: formattedTime,
                days: Array(self.selectedDays),
                message: self.reminderMessage
            )
            self.handleSaveOrUpdateResult(result)
        }
    }

    func updateReminder() {
        guard let id = currentReminder?.id else {
            state = .invalidInput(AppStrings.reminderNotFoundToUpdateError.letters)
            return
        }
        guard validateInput() else { return }
        state = .loading
        Task { [weak self] in
            guard let self else { return }
            let formattedTime = Self.timeFormatter.string(from: self.selectedDate)
            let result = await self.usecases.updateReminder(
                id: id,
                time: formattedTime,
                days: Array(self.selectedDays),
                message: self.reminderMessage
            )
            self.handleSaveOrUpdateResult(result)
        }
    }

    func deleteReminder() {
        guard let id = currentReminder?.id else {
            state = .invalidInput(AppStrings.reminderNotFoundToDeleteError.letters)
            return
        }
        state = .loading
        Task { [weak self] in
            guard let self else { return }
            let result = await self.usecases.deleteReminder(id: id)
            self.handleDeleteResult(result)
        }
    }
    
    private func handleLoadReminderResult(_ result: Result<[ReminderResponseEntity], Error>) {
        switch result {
        case .success(let reminders):
            self.currentReminder = reminders.first
            self.state = .success
        case .failure(let error):
            self.state = .requestFailed(self.asAppError(error))
        }
    }
    
    private func handleSaveOrUpdateResult(_ result: Result<ReminderResponseEntity, Error>) {
        switch result {
        case .success(let reminder):
            self.currentReminder = reminder
            self.state = .success
        case .failure(let error):
            self.state = .requestFailed(self.asAppError(error))
        }
    }

    private func handleDeleteResult(_ result: Result<Void, Error>) {
        switch result {
        case .success:
            self.currentReminder = nil
            self.state = .deleted
        case .failure(let error):
            self.state = .requestFailed(self.asAppError(error))
        }
    }
    
    private func validateInput() -> Bool {
        guard !selectedDays.isEmpty else {
            state = .invalidInput(AppStrings.noDaysSelectedError.letters)
            return false
        }
        return true
    }

    private func asAppError(_ error: Error) -> AppError<ApiErrorEnvelope> {
        (error as? AppError<ApiErrorEnvelope>) ?? .unknown(error)
    }
}
