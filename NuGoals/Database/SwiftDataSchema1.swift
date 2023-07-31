//
//  SwiftDataSchema1.swift
//  NuGoals
//

import Foundation
import SwiftData

/// This is the initial schema tweaked for SwiftData types with new fields
/// It would have lovely enums but SwiftData is fucking broken
enum SwiftDataSchema1: VersionedSchema {
    static var versionIdentifier: String? = "SwiftDataSchema1"

    static var models: [any PersistentModel.Type] {
        [Goal.self, Note.self, Alarm.self, Epoch.self, Icon.self]
    }

    /// * rename fields with CoreData implementation prefixes
    /// * drop SectionOrder
    /// * add Started and Abandoned
    @Model
    final class Goal {
        @Attribute(originalName: "cdCreationDate") var creationDate: Date = Date.now
        var startedDate: Date = Date.distantFuture
        var abandonedDate: Date = Date.distantFuture
        @Attribute(originalName: "cdCompletionDate") var completionDate: Date = Date.distantFuture
        @Attribute(originalName: "cdCurrentSteps") private var _currentSteps: Int = 0
        @Attribute(originalName: "cdTotalSteps") private var _totalSteps: Int = 0
        var _isStarted: Bool = false
        var _isAbandoned: Bool = false
        @Attribute(originalName: "cdIsFav") var isFav: Bool = false
        var name: String = ""
        var sortOrder: Int64 = 0
        var tag: String? = nil

        @Relationship var icon: Icon
        @Relationship(.cascade, inverse: \Note.goal) var notes: [Note] = []

        init(icon: Icon) {
            self.icon = icon
        }

        fileprivate func migrateNewFields() {
            _isAbandoned = false
            if _currentSteps > 0 {
                _isStarted = true
                startedDate = creationDate
            } else {
                _isStarted = false
                startedDate = .distantFuture
            }
        }
    }

    /// * rename fields with CoreData implementation prefixes
    /// * drop DayStamp
    @Model
    final public class Note {
        @Attribute(originalName: "cdCreationDate") var creationDate: Date = Date.now
        var goalStatus: String? = nil
        var text: String = ""
        @Relationship var activeAlarm: Alarm? = nil
        @Relationship var defaultAlarm: Alarm? = nil
        @Relationship var goal: Goal? = nil

        init() {}
    }

    /// * rename fields with CoreData implementation prefixes
    /// * drop SectionOrder
    /// * can't intro enum field for type because SwiftData is broken...
    @Model
    final public class Alarm {
        @Attribute(originalName: "cdNextActiveDate") var nextActiveDate: Date = Date.distantFuture
        @Attribute(originalName: "cdType") private var _type: Int16 = 0
        @Attribute(originalName: "cdWeekDay") private var _weekDay: Int16 = 1
        var name: String = ""
        var notificationUid: String? = nil
        var sortOrder: Int64 = 0
        @Relationship(.cascade, inverse: \Note.activeAlarm) var activeNote: Note? = nil
        @Relationship(.cascade, inverse: \Note.defaultAlarm) var defaultNote: Note? = nil
        @Relationship var icon: Icon

        init(icon: Icon) {
            self.icon = icon
        }
    }

    /// * rename fields with CoreData implementation prefixes
    /// * drop SortOrder
    @Model
    final public class Epoch {
        @Attribute(originalName: "cdStartDate") var startDate: Date = Date.now
        @Attribute(originalName: "cdEndDate") var endDate: Date = Date.distantFuture
        @Attribute(originalName: "cdShortName") var shortName: String = ""
        @Attribute(originalName: "cdLongName") var longName: String = ""
        var majorVersion: Int64 = 0
        var minorVersion: Int64 = 0

        init() {}
    }

    /// * no changes - want to link over but can't figure out how because of circular rel type requirements
    @Model
    final class Icon {
        var imageData: Data
        var isBuiltin: Bool = false
        var name: String = ""
        var sortOrder: Int64 = 0
        @Relationship(inverse: \Alarm.icon) var usingAlarms: [Alarm] = []
        @Relationship(inverse: \Goal.icon) var usingGoals: [Goal] = []

        init(data: Data) {
            imageData = data
        }
    }

    // MARK: Migration

    static func willMigrate(context: ModelContext) {
    }

    static func didMigrate(context: ModelContext) {
        do {
            print("SwiftDataSchema1 migration: migrating goals fields")
            let goals = try context.fetch(FetchDescriptor<Goal>())
            for goal in goals {
                goal.migrateNewFields()
            }
            try context.save()
        } catch {
            print("Migration error, good luck: \(error)") // XXX logging
        }
    }
}
