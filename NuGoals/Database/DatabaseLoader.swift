//
//  DatabaseLoader.swift
//  NuGoals
//

import SwiftData
import Foundation

enum DatabaseLoader {
//    static let modelTypes: [any PersistentModel.Type] = [Goal.self, Alarm.self, Epoch.self, Note.self, Icon.self]
    static let modelTypes: [any PersistentModel.Type] = [CoreDataSchema.Goal.self, CoreDataSchema.Alarm.self, CoreDataSchema.Epoch.self, CoreDataSchema.Note.self, Icon.self]


    static let modelName = "DataModel"

    static var modelContainer: ModelContainer {
        // Tweak the defaults to match the Core Data settings of all this
        let appSupportURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let modelURL = appSupportURL.appending(path: "\(modelName).sqlite")
        let modelConfiguration = ModelConfiguration(modelName, url: modelURL)

        do {
            return try ModelContainer(for: modelTypes, /*migrationPlan: MigrationPlan.self, */modelConfiguration)
        } catch {
            print("Model init failed, falling back to in-memory: \(error)") // XXX logging
            let memoryConfiguration = ModelConfiguration(inMemory: true)
            return try! ModelContainer(for: CurrentSchema.models, memoryConfiguration)
        }
    }
}

enum CurrentSchema: VersionedSchema {
    static var versionIdentifier: String? = "Current Schema"

    static var models: [any PersistentModel.Type] {
        [Goal.self, Note.self, Alarm.self, Epoch.self, Icon.self]
    }
}

enum MigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [CoreDataSchema.self, CurrentSchema.self]
    }

    static var stages: [MigrationStage] {
        [migrateCoreDataToV1]
    }

    static let migrateCoreDataToV1 = MigrationStage.lightweight(
        fromVersion: CoreDataSchema.self,
        toVersion: CurrentSchema.self
    )
}
