//
//  Prefs.swift
//  NuGoals
//

import Foundation

enum Prefs {
    private enum Key: String {
        case coreDataMigrationDone
    }

    static var coreDataMigrationDone: Bool {
        get {
            bool(Key.coreDataMigrationDone.rawValue)
        }
        set {
            set(Key.coreDataMigrationDone.rawValue, to: newValue)
        }
    }

    public static func set(_ pref: String, to value: Bool) {
        UserDefaults.standard.set(value, forKey: pref)
    }

    public static func bool(_ pref: String) -> Bool {
        return UserDefaults.standard.bool(forKey: pref)
    }

    public static func set(_ pref: String, to value: Int) {
        UserDefaults.standard.set(value, forKey: pref)
    }

    public static func int(_ pref: String) -> Int {
        return UserDefaults.standard.integer(forKey: pref)
    }

    public static func set(_ pref: String, to value: String) {
        UserDefaults.standard.set(value, forKey: pref)
    }

    public static func string(_ pref: String) -> String {
        return UserDefaults.standard.string(forKey: pref) ?? ""
    }
}

