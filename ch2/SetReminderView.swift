//
//  SetReminderView.swift
//  ch2
//
//  Created by ريناد محمد حملي on 01/05/1447 AH.
//
import SwiftUI

struct SetReminderView: View {
    @State private var selectedRoom: String = "Bedroom"
    @State private var selectedLight: String = "Full sun"
    @State private var selectedWateringDays: String = "Every day"
    @State private var selectedWaterAmount: String = "20-50 ml"
    @State private var plantName: String = ""

    @Environment(\.dismiss) var dismiss
    var onSave: ((String, String, String, String) -> Void)?

    var body: some View {
        NavigationStack {
            List {
                // قسم اسم النبتة
                Section {
                    ZStack(alignment: .leading) {
                        if plantName.isEmpty {
                            Text("Plant Name")
                                .foregroundColor(.white.opacity(10)) // اللون الأبيض للـ placeholder
                        }
                        TextField("", text: $plantName)
                            .foregroundStyle(.white) // لون الكتابة أبيض
                            .keyboardType(.asciiCapable)
                    }
                }
                .listRowBackground(Color.customDarkGray)

                // قسم الموقع والإضاءة
                Section {
                    HStack {
                        Image(systemName: "paperplane")
                            .foregroundColor(.white)
                        Text("Room")
                            .foregroundColor(.white)
                        Spacer()
                        Menu {
                            Button("Living Room") { selectedRoom = "Living Room" }
                            Button("Bedroom") { selectedRoom = "Bedroom" }
                            Button("Kitchen") { selectedRoom = "Kitchen" }
                            Button("Balcony") { selectedRoom = "Balcony" }
                            Button("Bathroom") { selectedRoom = "Bathroom" }
                        } label: {
                            HStack {
                                Text(selectedRoom)
                                Image(systemName: "chevron.up.chevron.down")
                                    .font(.caption2)
                            }
                            .foregroundStyle(.gray)
                        }
                    }
                    
                    HStack {
                        Image(systemName: lightIcon(for: selectedLight))
                            .foregroundColor(.white)
                        Text("Light")
                            .foregroundColor(.white)
                        Spacer()
                        Menu {
                            Button { selectedLight = "Full sun" } label: { Label("Full sun", systemImage: "sun.max.fill") }
                            Button { selectedLight = "Partial sun" } label: { Label("Partial sun", systemImage: "sun.min.fill") }
                            Button { selectedLight = "Low Light" } label: { Label("Low Light", systemImage: "sun.haze.fill") }
                        } label: {
                            HStack {
                                Text(selectedLight)
                                Image(systemName: "chevron.up.chevron.down")
                                    .font(.caption2)
                            }
                            .foregroundStyle(.gray)
                        }
                    }
                }
                .listRowBackground(Color.customDarkGray)
                
                // قسم السقي والماء
                Section {
                    HStack {
                        Image(systemName: "drop")
                            .foregroundColor(.white)
                        Text("Watering Days")
                            .foregroundColor(.white)
                        Spacer()
                        Menu {
                            Button("Every day") { selectedWateringDays = "Every day" }
                            Button("Every 2 days") { selectedWateringDays = "Every 2 days" }
                            Button("Every 3 days") { selectedWateringDays = "Every 3 days" }
                            Button("Once a week") { selectedWateringDays = "Once a week" }
                            Button("Every 10 days") { selectedWateringDays = "Every 10 days" }
                            Button("Every 2 weeks") { selectedWateringDays = "Every 2 weeks" }
                        } label: {
                            HStack {
                                Text(selectedWateringDays)
                                Image(systemName: "chevron.up.chevron.down")
                                    .font(.caption2)
                            }
                            .foregroundStyle(.gray)
                        }
                    }
                    
                    HStack {
                        Image(systemName: "drop")
                            .foregroundColor(.white)
                        Text("Water")
                            .foregroundColor(.white)
                        Spacer()
                        Menu {
                            Button("20-50 ml") { selectedWaterAmount = "20-50 ml" }
                            Button("50-100 ml") { selectedWaterAmount = "50-100 ml" }
                            Button("100-200 ml") { selectedWaterAmount = "100-200 ml" }
                            Button("200-300 ml") { selectedWaterAmount = "200-300 ml" }
                        } label: {
                            HStack {
                                Text(selectedWaterAmount)
                                Image(systemName: "chevron.up.chevron.down")
                                    .font(.caption2)
                            }
                            .foregroundStyle(.gray)
                        }
                    }
                }
                .listRowBackground(Color.customDarkGray)
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color(hex: "#1C1E1D").ignoresSafeArea())
            .navigationTitle("Set Reminder")
            .navigationBarTitleDisplayMode(.inline)
            
            // أزرار عادية
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                    })
                    .buttonStyle(.borderedProminent)
                    .tint(Color("bottomNavigationButtonColor"))
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        onSave?(plantName, selectedRoom, selectedLight, selectedWaterAmount)
                        dismiss()
                    }, label: {
                        Image(systemName: "checkmark")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                    })
                    .buttonStyle(.borderedProminent)
                    .tint(Color("bottom1"))
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private func lightIcon(for light: String) -> String {
        switch light {
        case "Full sun":
            return "sun.max.fill"
        case "Partial sun":
            return "sun.min.fill"
        case "Low Light":
            return "sun.haze.fill"
        default:
            return "sun.max"
        }
    }
}

extension Color {
    static let customDarkGray = Color(red: 0.1, green: 0.1, blue: 0.1)
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    SetReminderView()
}
