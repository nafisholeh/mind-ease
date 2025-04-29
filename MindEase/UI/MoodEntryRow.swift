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
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center) {
                // Mood emoji with background
                ZStack {
                    Circle()
                        .fill(moodLevel.color.opacity(0.15))
                        .frame(width: 50, height: 50)

                    Text(moodLevel.emoji)
                        .font(.system(size: 30))
                        .shadow(color: .gray.opacity(0.1), radius: 1, x: 0, y: 1)
                }
                .padding(.trailing, 8)

                // Date, time and mood description
                VStack(alignment: .leading, spacing: 4) {
                    Text(moodLevel.description)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(moodLevel.color)

                    HStack(spacing: 4) {
                        Text(dateFormatter.string(from: entry.date ?? Date()))
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)

                        Text("•")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)

                        Text(timeFormatter.string(from: entry.date ?? Date()))
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()

                // Chevron indicator for iOS
                #if os(iOS)
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.gray.opacity(0.5))
                #endif
            }

            // Context factors if any
            if !contextFactors.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(contextFactors) { factor in
                            HStack(spacing: 4) {
                                Image(systemName: factor.iconName)
                                    .font(.system(size: 12))
                                    .foregroundColor(.blue)

                                Text(factor.rawValue)
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(.primary.opacity(0.8))
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(Color.blue.opacity(0.08))
                            )
                            .overlay(
                                Capsule()
                                    .stroke(Color.blue.opacity(0.1), lineWidth: 1)
                            )
                        }
                    }
                    .padding(.vertical, 4)
                }
            }

            // Notes if any
            if let notes = entry.notes, !notes.isEmpty {
                Text(notes)
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .padding(.top, 2)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.gray.opacity(0.1), radius: 5, x: 0, y: 2)
        )
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
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
