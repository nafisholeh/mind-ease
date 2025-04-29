//
//  MoodService.swift
//  MindEase
//
//  Created by Nafis on 30/04/25.
//

import Foundation
import CoreData
import SwiftUI

/// Service for managing mood entries
class MoodService {
    private let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }

    /// Creates a new mood entry
    /// - Parameters:
    ///   - moodLevel: The mood level selected by the user
    ///   - contextFactors: Optional array of context factors that might have affected the mood
    ///   - notes: Optional notes provided by the user
    /// - Returns: The newly created MoodEntry object
    func createMoodEntry(moodLevel: MoodLevel, contextFactors: [ContextFactor] = [], notes: String = "") -> MoodEntry {
        let newEntry = MoodEntry(context: viewContext)
        newEntry.date = Date()
        newEntry.moodLevel = moodLevel.rawValue
        newEntry.contextFactors = contextFactors.map { $0.rawValue }
        newEntry.notes = notes

        do {
            try viewContext.save()
            return newEntry
        } catch {
            // In a real app, we would handle this error more gracefully
            let nsError = error as NSError
            fatalError("Failed to save mood entry: \(nsError), \(nsError.userInfo)")
        }
    }

    /// Fetches all mood entries, sorted by date (most recent first)
    /// - Returns: Array of MoodEntry objects
    func fetchMoodEntries() -> [MoodEntry] {
        let request = NSFetchRequest<MoodEntry>(entityName: "MoodEntry")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \MoodEntry.date, ascending: false)]

        do {
            return try viewContext.fetch(request)
        } catch {
            let nsError = error as NSError
            fatalError("Failed to fetch mood entries: \(nsError), \(nsError.userInfo)")
        }
    }

    /// Deletes a mood entry
    /// - Parameter entry: The MoodEntry to delete
    func deleteMoodEntry(_ entry: MoodEntry) {
        viewContext.delete(entry)

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Failed to delete mood entry: \(nsError), \(nsError.userInfo)")
        }
    }

    /// Helper method to convert stored context factors to ContextFactor enum values
    /// - Parameter entry: The MoodEntry containing context factors
    /// - Returns: Array of ContextFactor enum values
    func getContextFactors(for entry: MoodEntry) -> [ContextFactor] {
        guard let factorStrings = entry.contextFactors as? [String] else {
            return []
        }

        return factorStrings.compactMap { ContextFactor(rawValue: $0) }
    }

    /// Helper method to get the MoodLevel enum value from a MoodEntry
    /// - Parameter entry: The MoodEntry
    /// - Returns: The corresponding MoodLevel enum value
    func getMoodLevel(for entry: MoodEntry) -> MoodLevel {
        return MoodLevel(rawValue: entry.moodLevel) ?? .neutral
    }
}
