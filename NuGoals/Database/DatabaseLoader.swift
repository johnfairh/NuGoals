//
//  DatabaseLoader.swift
//  NuGoals
//

import SwiftData
import Foundation
import UIKit

enum DatabaseLoader {
    static let modelTypes: [any PersistentModel.Type] = [Goal.self, Alarm.self, Epoch.self, Note.self, Icon.self]

    static let modelName = "DataModel"

    static var modelContainer: ModelContainer {
        let appSupportURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let modelURL = appSupportURL.appending(path: "\(modelName).sqlite")
        let modelConfiguration = ModelConfiguration(modelName, url: modelURL)

        do {
            return try ModelContainer(for: modelTypes, modelConfiguration)
        } catch {
            print("Model init failed, falling back to in-memory: \(error)") // XXX logging
            let memoryConfiguration = ModelConfiguration(inMemory: true)
            return try! ModelContainer(for: modelTypes, memoryConfiguration)
        }
    }
}
