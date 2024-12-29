import SwiftUI

struct HabitRowView: View {
    let habit: Habit
    @EnvironmentObject var viewModel: HabitMateViewModel
    
    var body: some View {
        HStack(spacing: 16) {
            // Main Content
            VStack(alignment: .leading, spacing: 4) {
                Text(habit.title)
                    .font(.headline)
                    .foregroundColor(habit.isCompleted ? .secondary : .primary)
                
                Text(habit.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                if let duration = habit.formattedDuration {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar.badge.clock")
                            .foregroundColor(.blue)
                        Text(duration)
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                    .padding(.top, 2)
                }
            }
            
            Spacer()
            
            // Streak indicator on the right
            if habit.streak > 0 {
                HStack(spacing: 4) {
                    Text("\(habit.streak)")
                        .font(.subheadline.bold())
                        .foregroundColor(.orange)
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                }
            }
        }
        .contentShape(Rectangle())
    }
}

#Preview {
    List {
        HabitRowView(habit: Habit(
            title: "Daily Exercise",
            description: "30 minutes of cardio",
            isCompleted: false,
            streak: 5,
            lastCompletedDate: Date(),
            duration: HabitDuration(type: .daily, amount: 1)
        ))
        HabitRowView(habit: Habit(
            title: "Read a Book",
            description: "Read at least 20 pages",
            isCompleted: true,
            streak: 3,
            lastCompletedDate: Date().addingTimeInterval(-86400),
            duration: HabitDuration(type: .weekly, amount: 2)
        ))
        HabitRowView(habit: Habit(
            title: "Meditation",
            description: "Morning mindfulness practice",
            isCompleted: false,
            streak: 0,
            duration: HabitDuration(type: .monthly, amount: 1)
        ))
    }
    .environmentObject(HabitMateViewModel())
} 
