//
//  TODY.swift
//  ch2
//
//  Created by ريناد محمد حملي on 01/05/1447 AH.
import SwiftUI

// 🌱 Plant Model
struct Plant: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var room: String
    var light: String
    var waterAmount: String
    var isWatered: Bool = false
}

// 🪴 Plant Row
struct PlantRow: View {
    @Binding var plant: Plant
    var onTap: (() -> Void)? = nil

    var body: some View {
        Button(action: { onTap?() }) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top) {
                    Button {
                        withAnimation {
                            plant.isWatered.toggle()
                        }
                    } label: {
                        Image(systemName: plant.isWatered ? "checkmark.circle.fill" : "circle")
                            .font(.title2)
                            .foregroundColor(plant.isWatered ? Color("bottom1") : .gray.opacity(0.8))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.trailing, 8)

                    VStack(alignment: .leading, spacing: 8) {
                        Text(plant.name)
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(.white)

                        HStack(spacing: 15) {
                            HStack(spacing: 4) {
                                Image(systemName: "sun.max")
                                    .font(.caption)
                                    .foregroundColor(Color(hex: "#CCC785"))
                                Text(plant.light)
                                    .font(.caption)
                                    .foregroundColor(Color(hex: "#CCC785"))
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(hex: "#18181D"))
                            .cornerRadius(6)

                            HStack(spacing: 4) {
                                Image(systemName: "drop")
                                    .font(.caption)
                                    .foregroundColor(Color(hex: "#CAF3FB"))
                                Text(plant.waterAmount)
                                    .font(.caption)
                                    .foregroundColor(Color(hex: "#CAF3FB"))
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(hex: "#18181D"))
                            .cornerRadius(6)
                        }

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

                Divider()
                    .background(Color.gray.opacity(0.3))
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// 📊 Progress Bar
struct ProgressBarView: View {
    let wateredCount: Int
    let totalCount: Int

    var progress: Double {
        guard totalCount > 0 else { return 0 }
        return Double(wateredCount) / Double(totalCount)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if wateredCount == 0 {
                Text("Your plants are waiting for a sip 💦")
                    .font(.headline)
                    .foregroundColor(.white)
            } else if wateredCount == totalCount {
                Text("All Done! 🎉")
                    .font(.headline)
                    .foregroundColor(Color("bottom1"))
            } else {
                Text("\(wateredCount) of your plants feel loved today ✨")
                    .font(.headline)
                    .foregroundColor(.white)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 8)

                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("bottom1"))
                        .frame(width: geometry.size.width * progress, height: 8)
                        .animation(.easeInOut(duration: 0.3), value: progress)
                }
            }
            .frame(height: 8)
        }
        .frame(height: 48)
    }
}

// 🎉 All Done View
struct AllDoneView: View {
    @Environment(\.dismiss) var dismiss
    var onAddPlant: () -> Void

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color.black.ignoresSafeArea()

            VStack(spacing: 30) {
                Spacer()
                Image("Image2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                Text("All Done! 🎉")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)

                Text("All Reminders Completed")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
                Spacer()
            }

            Button {
                dismiss()
                onAddPlant()
            } label: {
                Image(systemName: "plus")
                    .font(.title2)
                    .frame(width: 55, height: 55)
                    .background(Color("bottom1"))
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .shadow(radius: 5)
            }
            .padding(.bottom, 40)
            .padding(.trailing, 20)
        }
    }
}

// 📱 My Plants View
struct MyPlantsView: View {
    @State var plants: [Plant]
    @State private var showingSetReminder = false
    @State private var showingAllDone = false
    @State private var selectedPlant: Plant?
    @State private var showingEditPlant = false

    var wateredPlantsCount: Int { plants.filter { $0.isWatered }.count }

    var allPlantsWatered: Bool { !plants.isEmpty && wateredPlantsCount == plants.count }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color.black.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("My Plants🌱")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }

                Divider()
                    .background(Color.gray.opacity(0.3))
                    .padding(.bottom, 10)

                ProgressBarView(wateredCount: wateredPlantsCount, totalCount: plants.count)
                    .padding(.horizontal)

                List {
                    ForEach($plants) { $plant in
                        PlantRow(plant: $plant) {
                            selectedPlant = plant
                            showingEditPlant = true
                        }
                        .listRowBackground(Color.black)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
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

            Button {
                showingSetReminder = true
            } label: {
                Image(systemName: "plus")
                    .font(.title2)
                    .frame(width: 55, height: 55)
                    .background(Color("bottom1"))
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .shadow(radius: 5)
            }
            .padding(.bottom, 40)
            .padding(.trailing, 20)

            .sheet(isPresented: $showingSetReminder) {
                SetReminderView { name, room, light, waterAmount in
                    let newPlant = Plant(name: name, room: room, light: light, waterAmount: waterAmount)
                    plants.append(newPlant)
                }
            }

            .fullScreenCover(isPresented: $showingAllDone) {
                AllDoneView {
                    showingSetReminder = true
                }
            }
        }
        .onChange(of: wateredPlantsCount) { _ in
            if allPlantsWatered { showingAllDone = true }
        }
    }

    private func deletePlant(_ plant: Plant) {
        withAnimation {
            plants.removeAll { $0.id == plant.id }
        }
    }
}

#Preview {
    MyPlantsView(plants: [
        Plant(name: "Cactus", room: "Living Room", light: "Full sun", waterAmount: "20-50 ml"),
        Plant(name: "Aloe", room: "Balcony", light: "Partial sun", waterAmount: "50-100 ml")
    ])
}

