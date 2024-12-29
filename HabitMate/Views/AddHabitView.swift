import SwiftUI

struct AddHabitView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: HabitMateViewModel
    
    @State private var title = ""
    @State private var description = ""
    @State private var selectedReminder: Date = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date()
    @State private var isReminderEnabled = false
    @State private var isDurationEnabled = false
    @State private var durationType: DurationType = .daily
    @State private var durationAmount = 1
    
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
                        let habit = Habit(
                            title: title,
                            description: description,
                            isCompleted: false,
                            streak: 0,
                            duration: duration
                        )
                        viewModel.addHabit(habit)
                        dismiss()
                    } label: {
                        Text("Create Habit")
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
                
                Section(footer: Text("Start building your habit today!").frame(maxWidth: .infinity, alignment: .center)) {
                    EmptyView()
                }
            }
            .navigationTitle("New Habit")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                }
            )
        }
    }
}

#Preview {
    AddHabitView()
        .environmentObject(HabitMateViewModel())
} 