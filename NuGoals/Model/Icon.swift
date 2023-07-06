//
//  Icon.swift
//  NuGoals
//

import SwiftData
import Foundation
import UIKit

@Model final public class Icon {
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
