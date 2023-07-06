//
//  Alarm.swift
//  NuGoals
//

import struct Foundation.Date
import SwiftData

@Model final public class Alarm {
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
