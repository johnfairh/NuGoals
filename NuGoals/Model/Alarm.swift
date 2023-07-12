//
//  Alarm.swift
//  NuGoals
//

import struct Foundation.Date
import SwiftData

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

    init() {
        nextActiveDate = .distantFuture
        cdType = 0
        cdWeekDay = 1
        name = ""
        notificationUid = nil
        sortOrder = 0
    }
}
