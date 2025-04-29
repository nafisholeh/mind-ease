//
//  MoodHistoryView.swift
//  MindEase
//
//  Created by Nafis on 30/04/25.
//

import SwiftUI
import CoreData

/// View for displaying the history of mood entries
struct MoodHistoryView: View {
    @Environment(\.managedObjectContext) private var viewContext

    // Fetch request for mood entries
    @FetchRequest(
        entity: MoodEntry.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \MoodEntry.date, ascending: false)],
        animation: .default
    )
    private var moodEntries: FetchedResults<MoodEntry>

    // Service
    private let moodService: MoodService

    // State
    @State private var showingAddMoodEntry = false

    init(viewContext: NSManagedObjectContext? = nil) {
        let context = viewContext ?? PersistenceController.shared.container.viewContext
        self.moodService = MoodService(viewContext: context)
    }

    var body: some View {
        NavigationView {
            Group {
                if moodEntries.isEmpty {
                    // Empty state
                    VStack(spacing: 20) {
                        Image(systemName: "heart.text.square")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)

                        Text("No mood entries yet")
                            .font(.title2)
                            .fontWeight(.medium)

                        Text("Start tracking your mood to see your entries here.")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        Button(action: {
                            showingAddMoodEntry = true
                        }) {
                            Text("Add Your First Mood Entry")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding(.top, 20)
                    }
                    .padding()
                } else {
                    // List of mood entries
                    List {
                        ForEach(moodEntries) { entry in
                            MoodEntryRow(
                                entry: entry,
                                moodLevel: moodService.getMoodLevel(for: entry),
                                contextFactors: moodService.getContextFactors(for: entry)
                            )
                        }
                        .onDelete(perform: deleteMoodEntries)
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationTitle("Mood History")
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        showingAddMoodEntry = true
                    }) {
                        Label("Add Mood", systemImage: "plus")
                    }
                }

                #if os(iOS)
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                        .disabled(moodEntries.isEmpty)
                }
                #else
                ToolbarItem {
                    EditButton()
                        .disabled(moodEntries.isEmpty)
                }
                #endif
            }
            .sheet(isPresented: $showingAddMoodEntry) {
                AddMoodEntryView(viewContext: viewContext)
            }
        }
    }

    /// Deletes mood entries at the specified offsets
    private func deleteMoodEntries(offsets: IndexSet) {
        withAnimation {
            offsets.map { moodEntries[$0] }.forEach { entry in
                moodService.deleteMoodEntry(entry)
            }
        }
    }
}

#Preview {
    MoodHistoryView(viewContext: PersistenceController.preview.container.viewContext)
}
