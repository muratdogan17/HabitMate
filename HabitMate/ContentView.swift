//
//  ContentView.swift
//  HabitMate
//
//  Created by Murat Doğan on 23.12.2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: HabitMateViewModel
    @State private var isAddingHabit = false
    @State private var selectedCategory: HabitCategory = .all
    
    private func filterHabits(for category: HabitCategory) -> [Habit] {
        switch category {
        case .all:
            return viewModel.habits
        case .active:
            return viewModel.habits.filter { !$0.isCompleted }
        case .completed:
            return viewModel.habits.filter { $0.isCompleted }
        case .streaks:
            return viewModel.habits.filter { $0.streak > 0 }
        }
    }
    
    var filteredHabits: [Habit] {
        filterHabits(for: selectedCategory)
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.habits.isEmpty {
                    EmptyStateView(isAddingHabit: $isAddingHabit)
                        .transition(.opacity)
                } else {
                    ZStack {
                        Color(uiColor: .systemGroupedBackground)
                            .ignoresSafeArea()
                        
                        // Background Text
                        Text("HabitMate")
                            .font(.system(size: 60, weight: .bold, design: .rounded))
                            .foregroundStyle(.gray.opacity(0.1))
                            .frame(maxWidth: .infinity)
                            .frame(maxHeight: .infinity, alignment: .center)
                        
                        VStack(spacing: 0) {
                            // Content
                            ScrollView {
                                LazyVStack(spacing: 0) {
                                    ForEach(filteredHabits) { habit in
                                        NavigationLink {
                                            HabitDetailView(habitId: habit.id)
                                        } label: {
                                            HabitRowView(habit: habit)
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 12)
                                                .contentShape(Rectangle())
                                                .background(Color(uiColor: .systemBackground))
                                        }
                                        .buttonStyle(.plain)
                                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                            Button(role: .destructive) {
                                                if let index = viewModel.habits.firstIndex(where: { $0.id == habit.id }) {
                                                    viewModel.removeHabit(at: index)
                                                }
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                            }
                                        }
                                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                            Button {
                                                if let index = viewModel.habits.firstIndex(where: { $0.id == habit.id }) {
                                                    viewModel.toggleHabitCompletion(at: index)
                                                }
                                            } label: {
                                                Label(habit.isCompleted ? "Uncomplete" : "Complete", 
                                                      systemImage: habit.isCompleted ? "xmark.circle" : "checkmark.circle")
                                            }
                                            .tint(habit.isCompleted ? .red : .green)
                                        }
                                        
                                        if habit.id != filteredHabits.last?.id {
                                            Divider()
                                                .padding(.horizontal, 16)
                                        }
                                    }
                                }
                            }
                            .scrollContentBackground(.hidden)
                        }
                        
                        // Enhanced FAB
                        VStack {
                            Spacer()
                            Button {
                                isAddingHabit = true
                            } label: {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title2)
                                    Text("Create Habit")
                                        .font(.headline)
                                }
                                .padding(.horizontal, 24)
                                .padding(.vertical, 16)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                                .shadow(color: .black.opacity(0.2), radius: 4, y: 2)
                            }
                            .padding(.bottom, 24)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .transition(.opacity)
                }
            }
            .animation(.easeInOut, value: viewModel.habits.isEmpty)
            .toolbar {
                if !viewModel.habits.isEmpty {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Menu {
                            ForEach(HabitCategory.allCases) { category in
                                Button {
                                    selectedCategory = category
                                } label: {
                                    Label {
                                        Text(category.title)
                                    } icon: {
                                        if selectedCategory == category {
                                            Image(systemName: "checkmark")
                                        } else {
                                            Image(systemName: category.icon)
                                        }
                                    }
                                }
                            }
                        } label: {
                            HStack {
                                Image(systemName: selectedCategory.icon)
                                Text(selectedCategory.title)
                            }
                            .foregroundColor(.blue)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $isAddingHabit) {
            AddHabitView()
        }
    }
}

enum HabitCategory: String, CaseIterable, Identifiable {
    case all
    case active
    case completed
    case streaks
    
    var id: String { self.rawValue }
    
    var title: String {
        switch self {
        case .all: return "All Habits"
        case .active: return "Active"
        case .completed: return "Done"
        case .streaks: return "Streaks"
        }
    }
    
    var icon: String {
        switch self {
        case .all: return "list.bullet"
        case .active: return "circle"
        case .completed: return "checkmark.circle.fill"
        case .streaks: return "flame.fill"
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(HabitMateViewModel())
}