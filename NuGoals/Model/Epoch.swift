//
//  Epoch.swift
//  NuGoals
//

import SwiftData
import struct Foundation.Date

@Model
final public class Epoch {
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
