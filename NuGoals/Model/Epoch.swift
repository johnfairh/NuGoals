//
//  Epoch.swift
//  NuGoals
//

import SwiftData
import struct Foundation.Date

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
