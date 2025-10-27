//
//  PlantStartView.swift
//  ch2
//
//  Created by ريناد محمد حملي on 30/04/1447 AH.
import SwiftUI

struct PlantStartView: View {
    @State private var showSetReminder = false
    @State private var plants: [Plant] = [] // نخزن هنا النباتات المضافة

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                VStack(spacing: 0) {
                    VStack(spacing: 12) {
                        Text("My Plants 🌱")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 50)
                            .padding(.leading, 20)
                        Rectangle()
                            .fill(Color.gray.opacity(0.7))
                            .frame(height: 1)
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.bottom, 20)

                    Image("plant_pot")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .padding(.top, 40)

                    Spacer()
                        .frame(height: 40)

                    Text("Start your plant journey!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text("Now all your plants will be in one place and we will help you take care of them :)🪴")
                        .font(.callout)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 40)

                    Spacer()

                    Button(action: {
                        showSetReminder = true
                    }) {
                        Text("Set Plant Reminder")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 299, height: 45)
                            .background(Color("bottom1"))
                            .cornerRadius(30)
                    }
                    .padding(.bottom, 150)
                    .sheet(isPresented: $showSetReminder) {
                        // نحافظ على SetReminderView كما كان، لكن نمرر الonSave
                        SetReminderView { name, room, light, waterAmount in
                            let newPlant = Plant(name: name, room: room, light: light, waterAmount: waterAmount)
                            plants.append(newPlant)
                            showSetReminder = false
                        }
                        .presentationDetents([.large])
                    }

                    // NavigationLink فارغ ينفع لنقلك لصفحة MyPlants تلقائياً لو في نباتات
                    NavigationLink(destination: MyPlantsView(plants: plants), isActive: Binding(
                        get: { !plants.isEmpty },
                        set: { _ in }
                    )) {
                        EmptyView()
                    }
                }
            }
        }
    }
}

#Preview {
    PlantStartView()
}

