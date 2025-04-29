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
                VStack(spacing: 20) {
                    // Mood selection
                    MoodSlider(selectedMood: $selectedMood)
                        .padding(.vertical)

                    Divider()

                    // Context factors
                    ContextFactorSelector(selectedFactors: $selectedFactors)

                    Divider()

                    // Notes
                    VStack(alignment: .leading) {
                        Text("Additional Notes")
                            .font(.headline)
                            .padding(.bottom, 5)

                        TextEditor(text: $notes)
                            .frame(minHeight: 100)
                            .padding(8)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                    }
                    .padding()

                    // Save button
                    Button(action: saveMoodEntry) {
                        Text("Save Mood Entry")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("How are you feeling?")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem {
                    Button("Cancel") {
                        dismiss()
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
