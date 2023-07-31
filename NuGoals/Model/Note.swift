//
//  Note.swift
//  NuGoals
//

import Foundation
import SwiftData

extension Note {
    /// Convert a `Date` to an 8-char datestamp
    var dayStamp: String {
        creationDate.formatted(date: .long, time: .omitted)
    }
}

struct CollectionGroup<F, E>: Identifiable {
    let id = UUID()
    let groupID: F
    let group: [E]
}

extension Collection {
    func grouped<F: Equatable>(by keypath: KeyPath<Element, F>) -> [CollectionGroup<F, Element>] {
        var result: [CollectionGroup<F, Element>] = []
        guard let first else {
            return result
        }

        var current: (F, [Element]) = (first[keyPath: keypath], [])

        for next in self {
            let nextBy = next[keyPath: keypath]
            if nextBy == current.0 {
                current.1.append(next)
            } else {
                result.append(CollectionGroup(groupID: current.0, group: current.1))
                current = (nextBy, [next])
            }
        }

        return result
    }
}
