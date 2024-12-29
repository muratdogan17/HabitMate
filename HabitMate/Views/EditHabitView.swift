import SwiftUI

struct EditHabitView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: HabitMateViewModel
    let habit: Habit
    
    @State private var title: String
    @State private var description: String
    @State private var selectedReminder: Date
    @State private var isReminderEnabled: Bool
    @State private var isDurationEnabled: Bool
    @State private var durationType: DurationType
    @State private var durationAmount: Int
    
    init(habit: Habit) {
        self.habit = habit
        // Initialize state variables with habit's current values
        _title = State(initialValue: habit.title)
        _description = State(initialValue: habit.description)
        _selectedReminder = State(initialValue: habit.lastCompletedDate ?? Date())
        _isReminderEnabled = State(initialValue: false)
        _isDurationEnabled = State(initialValue: habit.duration != nil)
        _durationType = State(initialValue: habit.duration?.type ?? .daily)
        _durationAmount = State(initialValue: habit.duration?.amount ?? 1)
    }
    
    private var duration: HabitDuration? {
        isDurationEnabled ? HabitDuration(type: durationType, amount: durationAmount) : nil
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Habit Details")) {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description)
                }
                
                Section(header: Text("Frequency")) {
                    Toggle("Set Frequency", isOn: $isDurationEnabled)
                    
                    if isDurationEnabled {
                        Picker("Type", selection: $durationType) {
                            ForEach(DurationType.allCases, id: \.self) { type in
                                Text(type.rawValue)
                                    .tag(type)
                            }
                        }
                        
                        Stepper("Every \(durationAmount) \(durationType.rawValue.lowercased())\(durationAmount > 1 ? "s" : "")",
                               value: $durationAmount, in: 1...30)
                    }
                }
                
                Section(header: Text("Reminder")) {
                    Toggle("Daily Reminder", isOn: $isReminderEnabled)
                    
                    if isReminderEnabled {
                        DatePicker("Time",
                                 selection: $selectedReminder,
                                 displayedComponents: .hourAndMinute)
                    }
                }
                
                Section {
                    Button {
                        let updatedHabit = Habit(
                            title: title,
                            description: description,
                            isCompleted: habit.isCompleted,
                            streak: habit.streak,
                            lastCompletedDate: habit.lastCompletedDate,
                            duration: duration
                        )
                        if let index = viewModel.habits.firstIndex(where: { $0.id == habit.id }) {
                            viewModel.updateHabit(at: index, with: updatedHabit)
                        }
                        dismiss()
                    } label: {
                        Text("Save Changes")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                    }
                    .disabled(title.isEmpty)
                    .listRowBackground(title.isEmpty ? Color.blue.opacity(0.3) : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .listRowInsets(EdgeInsets())
            }
            .navigationTitle("Edit Habit")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                }
            )
        }
    }
}

#Preview {
    EditHabitView(habit: Habit(
        title: "Daily Exercise",
        description: "30 minutes of cardio",
        isCompleted: false,
        streak: 5,
        duration: HabitDuration(type: .daily, amount: 1)
    ))
    .environmentObject(HabitMateViewModel())
} 