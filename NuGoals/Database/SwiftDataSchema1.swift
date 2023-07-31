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
        @Attribute(originalName: "cdCreationDate") var creationDate: Date
        var startedDate: Date = Date.distantFuture // fuck you swiftdata
        var abandonedDate: Date = Date.distantFuture // fuck you swiftdata
        @Attribute(originalName: "cdCompletionDate") var completionDate: Date
        @Attribute(originalName: "cdCurrentSteps") private var _currentSteps: Int
        @Attribute(originalName: "cdTotalSteps") private var _totalSteps: Int
        var _isStarted: Bool = false // fuck you swiftdata
        var _isAbandoned: Bool = false // fuck you swiftdata
        @Attribute(originalName: "cdIsFav") var isFav: Bool
        var name: String
        var sortOrder: Int64
        var tag: String?

        @Relationship var icon: Icon
        @Relationship(.cascade, inverse: \Note.goal) var notes: [Note]

        init(icon: Icon) {
            creationDate = .now
            startedDate = .distantFuture
            abandonedDate = .distantFuture
            completionDate = .distantFuture
            _currentSteps = 0
            _totalSteps = 0
            _isStarted = false
            _isAbandoned = false
            isFav = false
            name = ""
            sortOrder = 0
            tag = nil
            self.icon = icon
            notes = []
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
        @Attribute(originalName: "cdCreationDate") var creationDate: Date
        var goalStatus: String?
        var text: String
        @Relationship var activeAlarm: Alarm?
        @Relationship var defaultAlarm: Alarm?
        @Relationship var goal: Goal?

        init() {
            creationDate = .now
            goalStatus = nil
            text = ""
            activeAlarm = nil
            defaultAlarm = nil
            goal = nil
        }
    }

    /// * rename fields with CoreData implementation prefixes
    /// * drop SectionOrder
    /// * can't intro enum field for type because SwiftData is broken...
    @Model
    final public class Alarm {
        @Attribute(originalName: "cdNextActiveDate") var nextActiveDate: Date
        @Attribute(originalName: "cdType") private var _type: Int16
        @Attribute(originalName: "cdWeekDay") private var _weekDay: Int16
        var name: String
        var notificationUid: String?
        var sortOrder: Int64
        @Relationship(.cascade, inverse: \Note.activeAlarm) var activeNote: Note?
        @Relationship(.cascade, inverse: \Note.defaultAlarm) var defaultNote: Note?
        @Relationship var icon: Icon

        init(icon: Icon) {
            nextActiveDate = .distantFuture
            _type = 0
            _weekDay = 1
            name = ""
            notificationUid = nil
            sortOrder = 0
            activeNote = nil
            defaultNote = nil
            self.icon = icon
        }
    }

    /// * rename fields with CoreData implementation prefixes
    /// * drop SortOrder
    @Model
    final public class Epoch {
        @Attribute(originalName: "cdStartDate") var startDate: Date
        @Attribute(originalName: "cdEndDate") var endDate: Date
        @Attribute(originalName: "cdShortName") var shortName: String
        @Attribute(originalName: "cdLongName") var longName: String
        var majorVersion: Int64
        var minorVersion: Int64

        init() {
            startDate = .now
            endDate = .distantFuture
            shortName = ""
            longName = ""
            majorVersion = 0
            minorVersion = 0
        }
    }

    /// * no changes - want to link over but can't figure out how because of circular rel type requirements
    @Model
    final class Icon {
        var imageData: Data
        var isBuiltin: Bool
        var name: String
        var sortOrder: Int64
        @Relationship(inverse: \Alarm.icon) var usingAlarms: [Alarm]
        @Relationship(inverse: \Goal.icon) var usingGoals: [Goal]

        init(data: Data) {
            imageData = data
            isBuiltin = false
            name = ""
            sortOrder = 0
            usingAlarms = []
            usingGoals = []
        }
    }

    static func willMigrate(context: ModelContext) {
    }

    static func didMigrate(context: ModelContext) {
        do {
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
