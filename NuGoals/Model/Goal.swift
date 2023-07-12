//
//  Goal.swift
//  NuGoals
//
//  Created by John on 26/06/2023.
//

import SwiftData
import struct Foundation.Date

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

    init() {
        completionDate = .distantFuture
        creationDate = .now
        _currentSteps = 0
        _totalSteps = 0
        isFav = false
        name = ""
        sortOrder = 0
        tag = nil
        notes = []
    }
}
