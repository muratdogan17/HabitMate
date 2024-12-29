import Foundation

class HabitMateViewModel: ObservableObject {
    @Published var habits: [Habit] = [] {
        didSet {
            saveHabits()
        }
    }
    
    private let userDefaultsKey = "savedHabits"
    
    init() {
        loadHabits()
        checkAndResetDailyHabits()
    }
    
    func addHabit(_ habit: Habit) {
        habits.append(habit)
    }
    
    func removeHabit(at index: Int) {
        habits.remove(at: index)
    }
    
    func updateHabit(at index: Int, with updatedHabit: Habit) {
        habits[index] = updatedHabit
    }
    
    func toggleHabitCompletion(at index: Int) {
        var habit = habits[index]
        let calendar = Calendar.current
        
        // If the habit was completed today, just toggle it off
        if habit.isCompleted {
            habit.isCompleted = false
            habit.lastCompletedDate = nil
            if habit.streak > 0 {
                habit.streak -= 1
            }
        } else {
            // Mark as completed
            habit.isCompleted = true
            habit.lastCompletedDate = Date()
            
            // Check if this completion continues the streak
            if let lastCompleted = habit.lastCompletedDate {
                let isYesterday = calendar.isDate(lastCompleted, inSameDayAs: calendar.date(byAdding: .day, value: -1, to: Date()) ?? Date())
                let isToday = calendar.isDate(lastCompleted, inSameDayAs: Date())
                
                if isToday || isYesterday {
                    habit.streak += 1
                } else {
                    habit.streak = 1 // Start new streak
                }
            } else {
                habit.streak = 1 // First completion
            }
        }
        
        habits[index] = habit
        saveHabits()
    }
    
    private func checkAndResetDailyHabits() {
        let calendar = Calendar.current
        
        for index in habits.indices {
            var habit = habits[index]
            
            // If the habit is completed and the last completion was not today
            if habit.isCompleted,
               let lastCompleted = habit.lastCompletedDate,
               !calendar.isDate(lastCompleted, inSameDayAs: Date()) {
                // Reset completion status for a new day
                habit.isCompleted = false
                habits[index] = habit
            }
        }
        
        // Save any changes
        if !habits.isEmpty {
            saveHabits()
        }
    }
    
    private func saveHabits() {
        if let encoded = try? JSONEncoder().encode(habits) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    private func loadHabits() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decoded = try? JSONDecoder().decode([Habit].self, from: data) {
            habits = decoded
        }
    }
} 