//
//  MindEaseApp.swift
//  MindEase
//
//  Created by Nafis on 30/04/25.
//

import SwiftUI

@main
struct MindEaseApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
