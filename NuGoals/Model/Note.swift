//
//  Note.swift
//  NuGoals
//

import struct Foundation.Date
import SwiftData

@Model
final public class Note {
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
