//
//  ContentView.swift
//  MindEase
//
//  Created by Nafis on 30/04/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    // State for tab selection
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            // Mood History Tab
            MoodHistoryTab()
                .environment(\.managedObjectContext, viewContext)
                .tabItem {
                    Label("Mood", systemImage: "heart.fill")
                }
                .tag(0)

            // Insights Tab (placeholder for future implementation)
            InsightsPlaceholderView()
                .tabItem {
                    Label("Insights", systemImage: "chart.bar.fill")
                }
                .tag(1)

            // Settings Tab (placeholder for future implementation)
            SettingsPlaceholderView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(2)
        }
    }
}

/// Temporary Mood History Tab until we can properly integrate the MoodHistoryView
struct MoodHistoryTab: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showingAddMood = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "heart.text.square")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)

                Text("Mood Tracking")
                    .font(.title)
                    .fontWeight(.bold)

                Text("Track your daily mood and see patterns over time")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Button(action: {
                    showingAddMood = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Mood Entry")
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding(.top, 20)
            }
            .padding()
            .navigationTitle("Mood History")
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        showingAddMood = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddMood) {
                Text("Add Mood Entry View")
                    .padding()
            }
        }
    }
}

/// Placeholder view for the Insights tab (to be implemented in future phases)
struct InsightsPlaceholderView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "chart.bar.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue)

            Text("Insights Coming Soon")
                .font(.title2)
                .fontWeight(.medium)

            Text("In the next update, you'll be able to see patterns and trends in your mood data.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
        .navigationTitle("Insights")
    }
}

/// Placeholder view for the Settings tab (to be implemented in future phases)
struct SettingsPlaceholderView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "gear")
                .font(.system(size: 60))
                .foregroundColor(.blue)

            Text("Settings Coming Soon")
                .font(.title2)
                .fontWeight(.medium)

            Text("In the next update, you'll be able to customize your MindEase experience.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
        .navigationTitle("Settings")
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
