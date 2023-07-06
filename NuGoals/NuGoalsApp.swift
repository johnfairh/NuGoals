//
//  NuGoalsApp.swift
//  NuGoals
//

import SwiftUI

@main
struct NuGoalsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(DatabaseLoader.modelContainer)
    }
}
