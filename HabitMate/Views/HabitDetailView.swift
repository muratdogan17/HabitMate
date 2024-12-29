import SwiftUI

struct HabitDetailView: View {
    let habitId: UUID
    @EnvironmentObject var viewModel: HabitMateViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showDeleteConfirmation = false
    @State private var showDeletedToast = false
    @State private var showEditSheet = false
    
    private var habit: Habit? {
        viewModel.habits.first { $0.id == habitId }
    }
    
    var body: some View {
        Group {
            if let habit = habit {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Hero Header
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text(habit.title)
                                    .font(.system(size: 34, weight: .bold))
                                    .foregroundStyle(.primary)
                                
                                Spacer()
                                
                                Circle()
                                    .fill(habit.isCompleted ? Color.green : Color.orange)
                                    .frame(width: 12, height: 12)
                            }
                            
                            Text(habit.description)
                                .font(.body)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.horizontal)
                        
                        // Stats Cards
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                // Status Card
                                StatCardView(
                                    icon: habit.isCompleted ? "checkmark.circle.fill" : "circle",
                                    iconColor: habit.isCompleted ? .green : .orange,
                                    title: "Status",
                                    value: habit.isCompleted ? "Completed" : "Active"
                                )
                                
                                // Streak Card
                                StatCardView(
                                    icon: "flame.fill",
                                    iconColor: .orange,
                                    title: "Current Streak",
                                    value: "\(habit.streak) days"
                                )
                                
                                // Frequency Card
                                if let duration = habit.formattedDuration {
                                    StatCardView(
                                        icon: "calendar.badge.clock",
                                        iconColor: .blue,
                                        title: "Frequency",
                                        value: duration
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Progress Section
                        if habit.streak > 0 {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Progress")
                                    .font(.title2)
                                    .bold()
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Image(systemName: "flame.fill")
                                            .foregroundStyle(.orange)
                                        Text("\(habit.streak) day streak")
                                            .foregroundStyle(.primary)
                                    }
                                    
                                    if let duration = habit.formattedDuration {
                                        Text("Keeping up with \(duration)")
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(uiColor: .secondarySystemGroupedBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                            }
                            .padding(.horizontal)
                        }
                        
                        Spacer(minLength: 32)
                        
                        // Primary Action Button
                        Button {
                            if let index = viewModel.habits.firstIndex(where: { $0.id == habit.id }) {
                                viewModel.toggleHabitCompletion(at: index)
                            }
                        } label: {
                            HStack {
                                Image(systemName: habit.isCompleted ? "xmark.circle" : "checkmark.circle")
                                Text(habit.isCompleted ? "Mark as Incomplete" : "Mark as Complete")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(habit.isCompleted ? .red : .green)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
                .background(Color(uiColor: .systemGroupedBackground))
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button {
                                showEditSheet = true
                            } label: {
                                Label("Edit Habit", systemImage: "pencil")
                            }
                            
                            Button(role: .destructive) {
                                showDeleteConfirmation = true
                            } label: {
                                Label("Delete Habit", systemImage: "trash")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .foregroundStyle(.primary)
                        }
                    }
                }
                .confirmationDialog(
                    "Delete Habit",
                    isPresented: $showDeleteConfirmation,
                    titleVisibility: .visible
                ) {
                    Button("Delete", role: .destructive) {
                        deleteHabit()
                    }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("Are you sure you want to delete '\(habit.title)'? This action cannot be undone.")
                }
                .overlay {
                    if showDeletedToast {
                        ToastView(message: "Habit deleted successfully")
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                }
                .sheet(isPresented: $showEditSheet) {
                    EditHabitView(habit: habit)
                }
            } else {
                // Handle case where habit is not found
                Text("Habit not found")
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    private func deleteHabit() {
        withAnimation {
            showDeletedToast = true
        }
        
        // Add a slight delay before dismissing
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if let index = viewModel.habits.firstIndex(where: { $0.id == habitId }) {
                viewModel.removeHabit(at: index)
                dismiss()
            }
        }
    }
}

// Toast View for feedback
struct ToastView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .font(.subheadline)
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(Color.black.opacity(0.8))
            )
            .shadow(radius: 4)
            .padding(.top, 8)
    }
}

struct StatCardView: View {
    let icon: String
    let iconColor: Color
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(iconColor)
            
            Text(value)
                .font(.headline)
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    HabitDetailView(habitId: UUID())
        .environmentObject(HabitMateViewModel())
}

