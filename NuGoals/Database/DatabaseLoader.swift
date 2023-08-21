//
//  DatabaseLoader.swift
//  NuGoals
//

import SwiftData
import Foundation

// SwiftData - the latest incomplete bullshit thing to get irate about
//
// If we just load a container against the core data v10 DB with the CoreDataSchema models, it works fine.
//
// But if we load a container against the same data but with a migrationplan set using the CoreDataSchema models
// as its first version then it craps out with "unknown model version".
//
// So we use a "just load it" the very first time, to do whatever underhanded bullshit SwiftData is doing, then
// replace that with a new container using the migration plan.
//
// If SwiftData can't init a container it doesn't seem to throw anything - just deletes the database and pretends
// everything worked.
// Update: if a *migration* fails then it does actually fail the init... no idea what state the DB is left in.

enum DatabaseLoader {
    private static let modelName = "DataModel"

    // XXX just use the ffdone appgroup??
    static let importExport = AppGroupImportExport(appGroup: "tml.NuGoals", filePrefix: modelName)

    static var modelContainer: ModelContainer {

        // TBD not actually using the app group yet
        // importExport.checkForImport()

        // Tweak the default filename settings to match the Core Data origins of all this
        let appSupportURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let modelURL = appSupportURL.appending(path: "\(modelName).sqlite")
        let modelConfiguration = ModelConfiguration(modelName, url: modelURL)
        print("Using data model \(modelURL.path)")

        do {
            if !Prefs.coreDataMigrationDone {
                print("Doing throwaway 1-time core-data migration")
                let _ = try ModelContainer(for: CoreDataSchema.models, modelConfiguration)
                Prefs.coreDataMigrationDone = true
                // atomicity shmatomicity
                print("1-time core-data migration done, going on to real container") // XXX logging
            } else {
                print("Core data migration done, using regular migration plan and schemas") // XXX logging
            }

            return try ModelContainer(for: CurrentSchema.models, migrationPlan: MigrationPlan.self, modelConfiguration)
        } catch {
            print("Model init failed, falling back to in-memory: \(error)") // XXX logging
            let memoryConfiguration = ModelConfiguration(inMemory: true)
            return try! ModelContainer(for: CurrentSchema.models, memoryConfiguration)
        }
    }
}

typealias CurrentSchema = SwiftDataSchema1

typealias Goal = CurrentSchema.Goal
typealias Note = CurrentSchema.Note
typealias Alarm = CurrentSchema.Alarm
typealias Epoch = CurrentSchema.Epoch
typealias Icon = CurrentSchema.Icon

enum MigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [CoreDataSchema.self,
         SwiftDataSchema1.self,
        ]
    }

    static var stages: [MigrationStage] {
        [migrateFromCoreData
        ]
    }

    static let migrateFromCoreData = MigrationStage.custom(
        fromVersion: CoreDataSchema.self,
        toVersion: SwiftDataSchema1.self,
        willMigrate: SwiftDataSchema1.willMigrate,
        didMigrate: SwiftDataSchema1.didMigrate
    )
}
