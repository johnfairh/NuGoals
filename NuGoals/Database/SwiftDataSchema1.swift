//
//  SwiftDataSchema1.swift
//  NuGoals
//

import Foundation
import SwiftData

/// This is the initial schema tweaked for SwiftData types with new fields and enums
enum SwiftDataSchema1: VersionedSchema {
    static var versionIdentifier: String? = "SwiftDataSchema1"

    static var models: [any PersistentModel.Type] {
        [Goal.self, Note.self, Alarm.self, Epoch.self, Icon.self]
    }

    /// * rename fields with CoreData implementation prefixes
    /// * drop SectionOrder
    @Model
    final class Goal {
        @Attribute(originalName: "cdCompletionDate") var completionDate: Date
        @Attribute(originalName: "cdCreationDate") var creationDate: Date
        @Attribute(originalName: "cdCurrentSteps") private var _currentSteps: Int
        @Attribute(originalName: "cdTotalSteps") private var _totalSteps: Int
        @Attribute(originalName: "cdIsFav") var isFav: Bool
        var name: String
        var sortOrder: Int64
        var tag: String?

        @Relationship var icon: Icon
        @Relationship(.cascade, inverse: \Note.goal) var notes: [Note]

        init(icon: Icon) {
            completionDate = .distantFuture
            creationDate = .now
            _currentSteps = 0
            _totalSteps = 0
            isFav = false
            name = ""
            sortOrder = 0
            tag = nil
            self.icon = icon
            notes = []
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
    @Model
    final public class Alarm {
        @Attribute(originalName: "cdNextActiveDate") var nextActiveDate: Date
        var cdType: Int16    // XXX
        var cdWeekDay: Int16 // XXX turn into enum
        var name: String
        var notificationUid: String?
        var sortOrder: Int64
        @Relationship(.cascade, inverse: \Note.activeAlarm) var activeNote: Note?
        @Relationship(.cascade, inverse: \Note.defaultAlarm) var defaultNote: Note?
        @Relationship var icon: Icon

        init(icon: Icon) {
            nextActiveDate = .distantFuture
            cdType = 0
            cdWeekDay = 1
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

    /// * no changes - want to link over
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
}
