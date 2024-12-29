import Foundation

enum DurationType: String, Codable, CaseIterable {
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
}

struct HabitDuration: Codable {
    var type: DurationType
    var amount: Int
    
    var description: String {
        switch type {
        case .daily:
            return amount == 1 ? "Daily" : "Every \(amount) days"
        case .weekly:
            return amount == 1 ? "Weekly" : "Every \(amount) weeks"
        case .monthly:
            return amount == 1 ? "Monthly" : "Every \(amount) months"
        }
    }
}

struct Habit: Identifiable, Codable {
    let id = UUID()
    let title: String
    let description: String
    var isCompleted: Bool
    var streak: Int
    var lastCompletedDate: Date?
    var duration: HabitDuration?
    
    init(title: String, 
         description: String, 
         isCompleted: Bool = false, 
         streak: Int = 0, 
         lastCompletedDate: Date? = nil,
         duration: HabitDuration? = nil) {
        self.title = title
        self.description = description
        self.isCompleted = isCompleted
        self.streak = streak
        self.lastCompletedDate = lastCompletedDate
        self.duration = duration
    }
    
    mutating func toggleCompletion() {
        isCompleted.toggle()
        if isCompleted {
            lastCompletedDate = Date()
            streak += 1
        } else {
            streak = 0
        }
    }
    
    var formattedDuration: String? {
        duration?.description
    }
} 