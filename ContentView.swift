//
//  ContentView.swift
//  ADHD Buddy
//
//  Created by Jasmine Jamshidi on 2024-11-22.
//

import SwiftUI

@StateObject private var firebaseManager = FirebaseManager.shared

struct ContentView: View {
    @State private var currentTime = Date()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // Define our pastel colors
    let colors = [
        Color(red: 182/255, green: 225/255, blue: 201/255),  // mint green
        Color(red: 255/255, green: 218/255, blue: 193/255),  // peach
        Color(red: 245/255, green: 239/255, blue: 230/255),  // light beige
        Color(red: 149/255, green: 199/255, blue: 199/255)   // muted teal
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                HStack {
                    Text(timeString(from: currentTime))
                        .font(.system(size: 24, weight: .bold))
                    Spacer()
                    Image(systemName: "house.fill")
                        .imageScale(.large)
                    Image(systemName: "bell.fill")
                        .imageScale(.large)
                        .padding(.leading, 15)
                }
                .padding(.horizontal)
                
                // Title Section
                Text("All Tasks Monitored")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                // Grid Layout
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 20) {
                    CategoryButton(icon: "key.fill", title: "Leaving Home", color: colors[0])
                    CategoryButton(icon: "cooktop.fill", title: "Cooking", color: colors[1])
                    CategoryButton(icon: "timer", title: "Custom Timers", color: colors[2])
                    CategoryButton(icon: "house.fill", title: "Home", color: colors[3])
                    CategoryButton(icon: "clock.fill", title: "Time Monitoring", color: colors[0])
                    CategoryButton(icon: "flame.fill", title: "Stove Monitoring", color: colors[1])
                }
                .padding()
                
                // Notifications List
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(firebaseManager.notifications) { notification in
                            NotificationView(notification: notification)
                        }
                    }
                    .padding()
                }
                
                Spacer()
                
                // Bottom Navigation Bar
                HStack {
                    Spacer()
                    Image(systemName: "bell.fill")
                        .imageScale(.large)
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding()
                .background(Color.white)
                .overlay(
                    Text("Voice Command")
                        .font(.caption)
                        .padding(.trailing)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                )
            }
        }
        .onReceive(timer) { input in
            currentTime = input
        }
    }
    
    private func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm"
        return formatter.string(from: date)
    }
}

struct CategoryButton: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        Button(action: {
            // Handle button tap
        }) {
            VStack {
                Image(systemName: icon)
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .background(color)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(radius: 5)
                
                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

struct NotificationView: View {
    let notification: Notification
    
    var body: some View {
        HStack {
            Image(systemName: notification.type.icon)
                .foregroundColor(.white)
                .padding(8)
                .background(Color.blue)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(notification.message)
                    .font(.system(size: 16))
                Text(notification.timestamp, style: .time)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

#Preview {
    ContentView()
}
