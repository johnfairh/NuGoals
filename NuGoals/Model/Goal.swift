//
//  Goal.swift
//  NuGoals
//
//  Created by John on 26/06/2023.
//

import SwiftData
import struct Foundation.Date

@Model
class Goal {
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

