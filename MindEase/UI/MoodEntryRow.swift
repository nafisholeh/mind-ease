//
//  MoodEntryRow.swift
//  MindEase
//
//  Created by Nafis on 30/04/25.
//

import SwiftUI

/// A row component for displaying a single mood entry
struct MoodEntryRow: View {
    let entry: MoodEntry
    let moodLevel: MoodLevel
    let contextFactors: [ContextFactor]

    // Date formatters
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                // Date and time
                VStack(alignment: .leading) {
                    Text(dateFormatter.string(from: entry.date ?? Date()))
                        .font(.headline)

                    Text(timeFormatter.string(from: entry.date ?? Date()))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Spacer()

                // Mood emoji and level
                HStack {
                    Text(moodLevel.emoji)
                        .font(.system(size: 30))

                    Text(moodLevel.description)
                        .font(.headline)
                        .foregroundColor(moodLevel.color)
                }
            }

            // Context factors if any
            if !contextFactors.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(contextFactors) { factor in
                            HStack {
                                Image(systemName: factor.iconName)
                                    .font(.caption)

                                Text(factor.rawValue)
                                    .font(.caption)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                }
            }

            // Notes if any
            if let notes = entry.notes, !notes.isEmpty {
                Text(notes)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let entry = MoodEntry(context: context)
    entry.date = Date()
    entry.moodLevel = 4
    entry.notes = "Had a good day at work, but feeling a bit tired."
    entry.contextFactors = ["Work", "Sleep"]

    let moodService = MoodService(viewContext: context)

    return MoodEntryRow(
        entry: entry,
        moodLevel: moodService.getMoodLevel(for: entry),
        contextFactors: moodService.getContextFactors(for: entry)
    )
    .padding()
    .previewLayout(.sizeThatFits)
}
