//
//  TODY.swift
//  ch2
//
//  Created by ريناد محمد حملي on 01/05/1447 AH.
//
import SwiftUI

// =================================================================
// 0. الهيكل والبيانات (Plant Model)
// =================================================================
struct Plant: Identifiable {
    let id = UUID()
    let name: String
    let room: String
    let light: String
    let waterAmount: String
    var isWatered: Bool = false
}

extension Plant {
    static let samplePlants: [Plant] = [
        Plant(name: "Pothos", room: "Living Room", light: "Full sun", waterAmount: "20-50 ml"),
        Plant(name: "Orchid", room: "Living Room", light: "Full sun", waterAmount: "20-50 ml"),
        Plant(name: "Monstera", room: "Kitchen", light: "Full sun", waterAmount: "20-50 ml"),
        Plant(name: "Spider", room: "Bedroom", light: "Full sun", waterAmount: "20-50 ml")
    ]
}

// =================================================================
// 0.2 دالة مساعدة لإنشاء صف النبتة (Plant Row)
// =================================================================
struct PlantRow: View {
    @Binding var plant: Plant
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top) {
                // ⬅️ الدائرة على اليسار للتشيك
                Button {
                    plant.isWatered.toggle()
                } label: {
                    Image(systemName: plant.isWatered ? "checkmark.circle.fill" : "circle")
                        .font(.title2)
                        .foregroundColor(plant.isWatered ? .green : .gray.opacity(0.8))
                }
                .padding(.trailing, 8)
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    // اسم النبتة (Pothos, Orchid) - كبير وأبيض
                    Text(plant.name)
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                    
                    // معلومات الإضاءة والماء في سطر واحد
                    HStack(spacing: 15) {
                        // الإضاءة - لون ذهبي
                        HStack(spacing: 4) {
                            Image(systemName: "sun.max")
                                .font(.caption)
                                .foregroundColor(.orange)
                            Text(plant.light)
                                .font(.caption)
                                .foregroundColor(.orange)
                        }
                        
                        // الماء - لون أزرق
                        HStack(spacing: 4) {
                            Image(systemName: "drop")
                                .font(.caption)
                                .foregroundColor(.blue)
                            Text(plant.waterAmount)
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                    }
                    
                    // الموقع - رمادي
                    HStack(spacing: 4) {
                        Image(systemName: "paperplane")
                            .font(.caption2)
                            .foregroundColor(.gray)
                        Text("in \(plant.room)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            
            // ⬅️ الخط الفاصل بين الصفوف - زي الكود الأصلي
            Divider()
                .background(Color.gray.opacity(0.3))
        }
    }
}

// =================================================================
// 1. MyPlantsView (شاشة القائمة الرئيسية)
// =================================================================
struct MyPlantsView: View {
    @State private var plants: [Plant] = Plant.samplePlants
    @State private var showingSetReminder = false
    
    // حساب عدد النباتات المسقية
    var wateredPlantsCount: Int {
        plants.filter { $0.isWatered }.count
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color.black.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 10) {
                
                // العنوان العلوي
                Group {
                    HStack {
                        Text("My Plants🌱")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    
                    // شريط الحالة - بيتغير حسب عدد النباتات المسقية
                    HStack {
                        if wateredPlantsCount == 0 {
                            Text("Your plants are waiting for a sip💦")
                                .font(.headline)
                                .foregroundColor(.white)
                        } else {
                            Text("\(wateredPlantsCount) of your plants feel loved today✨")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.bottom, 10)
                    
                    // خط فاصل أسفل العنوان
                    Rectangle()
                        .fill(Color.gray.opacity(0.5))
                        .frame(height: 1)
                }
                .padding(.horizontal)
                
                // قائمة النباتات مع خاصية الحذف
                List {
                    ForEach($plants) { $plant in
                        PlantRow(plant: $plant)
                            .listRowBackground(Color.black)
                            .listRowSeparator(.hidden) // ⬅️ إخفاء الخط الافتراضي للقائمة
                            .listRowInsets(EdgeInsets())
                            // ⬅️ إضافة خاصية السحب للحذف
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    // إزالة النبتة من المصفوفة
                                    deletePlant(plant)
                                } label: {
                                    Label("Delete", systemImage: "trash.fill")
                                }
                                .tint(.red)
                            }
                    }
                }
                .listStyle(.plain)
            }
            .padding(.top, 20)

            // زر إضافة نبتة (+) في الزاوية
            Button {
                showingSetReminder = true
            } label: {
                Image(systemName: "plus")
                    .font(.title2)
                    .frame(width: 55, height: 55)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .shadow(radius: 5)
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 40, trailing: 20))
            
            // شاشة إضافة نبتة جديدة
            .sheet(isPresented: $showingSetReminder) {
                SetReminderView { name, room, light, waterAmount in
                    // إضافة النبتة الجديدة للقائمة
                    let newPlant = Plant(
                        name: name,
                        room: room,
                        light: light,
                        waterAmount: waterAmount
                    )
                    plants.append(newPlant)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    // ⬅️ دالة لحذف النبتة
    private func deletePlant(_ plant: Plant) {
        withAnimation {
            plants.removeAll { $0.id == plant.id }
        }
    }
}

#Preview {
    MyPlantsView()
}
