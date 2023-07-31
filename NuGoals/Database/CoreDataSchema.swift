//
//  CoreDataSchema.swift
//  NuGoals
//

import Foundation
import SwiftData

/// This is the schema that comes out directly loading the latest Core Data version of the model
enum CoreDataSchema: VersionedSchema {
    static var versionIdentifier: String? = "DataModel-10"

    static var models: [any PersistentModel.Type] {
        [Goal.self, Note.self, Alarm.self, Epoch.self, Icon.self]
    }

    @Model
    final class Goal {
        var cdCompletionDate: Date
        var cdCreationDate: Date
        var cdCurrentSteps: Int32
        var cdIsFav: Bool
        var cdTotalSteps: Int32
        var name: String
        var sectionOrder: String
        var sortOrder: Int64
        var tag: String?

        @Relationship var icon: Icon
        @Relationship(.cascade, inverse: \Note.goal) var notes: [Note]

        init() {}
    }

    @Model
    final class Note {
        var cdCreationDate: Date
        var dayStamp: String
        var goalStatus: String?
        var text: String
        @Relationship var activeAlarm: Alarm?
        @Relationship var defaultAlarm: Alarm?
        @Relationship var goal: Goal?

        init() {}
    }

    @Model
    final class Alarm {
        var cdNextActiveDate: Date
        var cdType: Int16
        var cdWeekDay: Int16
        var name: String
        var notificationUid: String?
        @Transient var sectionOrder: String?
        var sortOrder: Int64
        @Relationship(.cascade, inverse: \Note.activeAlarm) var activeNote: Note?
        @Relationship(.cascade, inverse: \Note.defaultAlarm) var defaultNote: Note?
        @Relationship var icon: Icon
        
        init() {}
    }

    @Model
    final class Epoch {
        var cdEndDate: Date
        var cdLongName: String
        var cdShortName: String
        var cdStartDate: Date
        var majorVersion: Int64
        var minorVersion: Int64
        var sortOrder: Int64

        init() {}
    }

    @Model
    final class Icon {
        var imageData: Data
        var isBuiltin: Bool
        var name: String
        var sortOrder: Int64
        @Relationship(inverse: \Alarm.icon) var usingAlarms: [Alarm]
        @Relationship(inverse: \Goal.icon) var usingGoals: [Goal]

        init() {}
    }
}
