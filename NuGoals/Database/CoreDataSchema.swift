//
//  CoreDataSchema.swift
//  NuGoals
//

import Foundation
import SwiftData

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

        init() {
            cdCompletionDate = .distantFuture
            cdCreationDate = .now
            cdCurrentSteps = 0
            cdIsFav = false
            cdTotalSteps = 0
            name = ""
            sectionOrder = "0"
            sortOrder = 0
            tag = nil
            notes = []
        }
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

        init() {
            cdCreationDate = .now
            dayStamp = ""
            goalStatus = nil
            text = ""
        }
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
        
        init() {
            cdNextActiveDate = .distantFuture
            cdType = 0
            cdWeekDay = 1
            name = ""
            notificationUid = nil
            sectionOrder = nil
            sortOrder = 0
        }
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

        init() {
            cdEndDate = .distantFuture
            cdLongName = ""
            cdShortName = ""
            cdStartDate = .now
            majorVersion = 0
            minorVersion = 0
            sortOrder = 0
        }
    }

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
