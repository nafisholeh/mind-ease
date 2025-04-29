//
//  Persistence.swift
//  MindEase
//
//  Created by Nafis on 30/04/25.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext

        // Create sample mood entries for preview
        let calendar = Calendar.current

        // Sample mood entry 1 (today)
        let entry1 = MoodEntry(context: viewContext)
        entry1.date = Date()
        entry1.moodLevel = 4 // Good
        entry1.notes = "Had a productive day at work and enjoyed a nice walk outside."
        entry1.contextFactors = ["Work", "Exercise"]

        // Sample mood entry 2 (yesterday)
        let entry2 = MoodEntry(context: viewContext)
        entry2.date = calendar.date(byAdding: .day, value: -1, to: Date())
        entry2.moodLevel = 3 // Neutral
        entry2.notes = "Feeling a bit tired today, but otherwise okay."
        entry2.contextFactors = ["Sleep"]

        // Sample mood entry 3 (two days ago)
        let entry3 = MoodEntry(context: viewContext)
        entry3.date = calendar.date(byAdding: .day, value: -2, to: Date())
        entry3.moodLevel = 5 // Very Good
        entry3.notes = "Great day! Caught up with friends and had a delicious dinner."
        entry3.contextFactors = ["Social Interaction", "Nutrition"]

        // Sample mood entry 4 (three days ago)
        let entry4 = MoodEntry(context: viewContext)
        entry4.date = calendar.date(byAdding: .day, value: -3, to: Date())
        entry4.moodLevel = 2 // Bad
        entry4.notes = "Stressful day at work with tight deadlines."
        entry4.contextFactors = ["Work", "Stress"]

        // Also create some sample items (original template data)
        for _ in 0..<3 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }

        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "MindEase")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
