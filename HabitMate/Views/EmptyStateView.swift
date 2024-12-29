import SwiftUI

struct EmptyStateView: View {
    // Define premium colors
    private let primaryColor = Color(hex: "1B365D")  // Deep Navy
    private let accentColor = Color(hex: "FFA726")   // Warm Gold
    private let backgroundBase = Color(hex: "F5F7FA") // Light Gray-Blue
    
    @Binding var isAddingHabit: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            // Illustration
            Image(systemName: "list.star")
                .font(.system(size: 90))
                .foregroundStyle(
                    LinearGradient(
                        colors: [accentColor, accentColor.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .padding()
                .background(
                    Circle()
                        .fill(accentColor.opacity(0.1))
                        .frame(width: 140, height: 140)
                )
                .overlay(
                    Circle()
                        .stroke(accentColor.opacity(0.2), lineWidth: 1)
                        .frame(width: 160, height: 160)
                )
            
            // Text Content
            VStack(spacing: 16) {
                Text("Start Your Journey")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(primaryColor)
                
                Text("Create your first habit and begin tracking your progress towards a better you.")
                    .font(.body)
                    .foregroundColor(primaryColor.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            // CTA Button
            Button {
                isAddingHabit = true
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "plus.circle.fill")
                    Text("Create Your First Habit!")
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        colors: [primaryColor, primaryColor.opacity(0.9)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 32)
                .shadow(color: primaryColor.opacity(0.2), radius: 8, y: 4)
            }
        }
        .frame(maxHeight: .infinity)
        .background(backgroundBase)
    }
}

// Add this extension for hex color support
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    EmptyStateView(isAddingHabit: .constant(false))
} 
