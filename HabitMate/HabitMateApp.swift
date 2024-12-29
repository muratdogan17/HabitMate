//
//  HabitMateApp.swift
//  HabitMate
//
//  Created by Murat Doğan on 23.12.2024.
//

import SwiftUI

@main
struct HabitMateApp: App {
    @StateObject private var viewModel = HabitMateViewModel()
    
    init() {
        
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
