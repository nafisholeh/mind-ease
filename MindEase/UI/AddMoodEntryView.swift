//
//  AddMoodEntryView.swift
//  MindEase
//
//  Created by Nafis on 30/04/25.
//

import SwiftUI

/// View for adding a new mood entry
struct AddMoodEntryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    // State variables
    @State private var selectedMood: MoodLevel = .neutral
    @State private var selectedFactors: [ContextFactor] = []
    @State private var notes: String = ""

    // Service
    private let moodService: MoodService

    init(viewContext: NSManagedObjectContext? = nil) {
        let context = viewContext ?? PersistenceController.shared.container.viewContext
        self.moodService = MoodService(viewContext: context)
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // Mood selection
                    VStack {
                        Text("How are you feeling?")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .padding(.top, 10)
                            .padding(.bottom, 5)
                            .accessibilityAddTraits(.isHeader)

                        MoodSlider(selectedMood: $selectedMood)
                            .padding(.vertical, 5)
                    }
                    .padding(.horizontal)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: Color.gray.opacity(0.1), radius: 10, x: 0, y: 2)
                    )
                    .padding(.horizontal)

                    // Context factors
                    VStack {
                        ContextFactorSelector(selectedFactors: $selectedFactors)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: Color.gray.opacity(0.1), radius: 10, x: 0, y: 2)
                    )
                    .padding(.horizontal)

                    // Notes
                    VStack(alignment: .leading) {
                        Text("Additional Notes")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .padding(.bottom, 10)
                            .padding(.leading, 5)

                        ZStack(alignment: .topLeading) {
                            if notes.isEmpty {
                                Text("Add any additional thoughts here...")
                                    .foregroundColor(.gray.opacity(0.7))
                                    .font(.system(size: 15))
                                    .padding(.top, 8)
                                    .padding(.leading, 5)
                            }

                            TextEditor(text: $notes)
                                .frame(minHeight: 120)
                                .opacity(notes.isEmpty ? 0.25 : 1)
                        }
                        .padding(5)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.05))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: Color.gray.opacity(0.1), radius: 10, x: 0, y: 2)
                    )
                    .padding(.horizontal)

                    // Save button
                    Button(action: saveMoodEntry) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 20))

                            Text("Save Mood Entry")
                                .font(.system(size: 18, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 3)
                    }
                    .padding(.horizontal, 25)
                    .padding(.top, 10)
                    .padding(.bottom, 30)
                }
                .padding(.vertical)
            }
            .background(Color.gray.opacity(0.03).edgesIgnoringSafeArea(.all))
            .navigationTitle("Add Mood Entry")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Cancel")
                            .foregroundColor(.blue)
                            .fontWeight(.medium)
                    }
                }
            }
        }
    }

    /// Saves the current mood entry and dismisses the view
    private func saveMoodEntry() {
        moodService.createMoodEntry(
            moodLevel: selectedMood,
            contextFactors: selectedFactors,
            notes: notes
        )

        dismiss()
    }
}

#Preview {
    AddMoodEntryView(viewContext: PersistenceController.preview.container.viewContext)
}
