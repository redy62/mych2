//
//  SetReminderView.swift
//  ch2
//
//  Created by ريناد محمد حملي on 01/05/1447 AH.
//

import SwiftUI

struct SetReminderView: View {
    @State private var selectedRoom: String = "Living Room"
    @State private var selectedLight: String = "Full sun"
    @State private var selectedWateringDays: String = "Every day"
    @State private var selectedWaterAmount: String = "20-50 ml"
    @State private var plantName: String = "Pothos" // ⬅️ مليان من البداية

    @Environment(\.dismiss) var dismiss
    var onSave: ((String, String, String, String) -> Void)? // ⬅️ فيه onSave

    var body: some View {
        NavigationStack {
            List {
                // 1. قسم اسم النبتة
                Section {
                    TextField("Plant Name", text: $plantName)
                        .foregroundStyle(.white)
                }
                .listRowBackground(Color.customDarkGray)

                // 2. قسم الموقع والإضاءة
                Section {
                    HStack {
                        Image(systemName: "paperplane")
                        Text("Room")
                        Spacer()
                        Menu {
                            Button("Living Room") { selectedRoom = "Living Room" }
                            Button("Bedroom") { selectedRoom = "Bedroom" }
                            Button("Kitchen") { selectedRoom = "Kitchen" }
                        } label: {
                            HStack {
                                Text(selectedRoom)
                                Image(systemName: "chevron.right").font(.caption)
                            }
                            .foregroundStyle(.gray)
                        }
                    }
                    
                    HStack {
                        Image(systemName: "sun.max")
                        Text("Light")
                        Spacer()
                        Menu {
                            Button("Full sun") { selectedLight = "Full sun" }
                            Button("Partial sun") { selectedLight = "Partial sun" }
                            Button("Shade") { selectedLight = "Shade" }
                        } label: {
                            HStack {
                                Text(selectedLight)
                                Image(systemName: "chevron.right").font(.caption)
                            }
                            .foregroundStyle(.gray)
                        }
                    }
                }
                .listRowBackground(Color.customDarkGray)
                
                // 3. قسم السقي والماء
                Section {
                    HStack {
                        Image(systemName: "drop")
                        Text("Watering Days")
                        Spacer()
                        Menu {
                            Button("Every day") { selectedWateringDays = "Every day" }
                            Button("Every 2 days") { selectedWateringDays = "Every 2 days" }
                            Button("Once a week") { selectedWateringDays = "Once a week" }
                        } label: {
                            HStack {
                                Text(selectedWateringDays)
                                Image(systemName: "chevron.right").font(.caption)
                            }
                            .foregroundStyle(.gray)
                        }
                    }
                    
                    HStack {
                        Image(systemName: "drop")
                        Text("Water")
                        Spacer()
                        Menu {
                            Button("10-20 ml") { selectedWaterAmount = "10-20 ml" }
                            Button("20-50 ml") { selectedWaterAmount = "20-50 ml" }
                            Button("50-100 ml") { selectedWaterAmount = "50-100 ml" }
                        } label: {
                            HStack {
                                Text(selectedWaterAmount)
                                Image(systemName: "chevron.right").font(.caption)
                            }
                            .foregroundStyle(.gray)
                        }
                    }
                }
                .listRowBackground(Color.customDarkGray)
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color.black.ignoresSafeArea())
            
            .navigationTitle("Set Reminder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(8)
                    }
                    .background(Color.gray)
                    .clipShape(Circle())
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // حفظ النبتة الجديدة - دايماً شغال
                        onSave?(plantName, selectedRoom, selectedLight, selectedWaterAmount)
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title)
                            .foregroundStyle(.green) // ⬅️ دايماً أخضر
                    }
                    // ⬅️ لا يوجد disabled - دايماً شغال
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

// إضافة اللون المخصص
extension Color {
    static let customDarkGray = Color(red: 0.1, green: 0.1, blue: 0.1)
}

#Preview {
    SetReminderView()
}
