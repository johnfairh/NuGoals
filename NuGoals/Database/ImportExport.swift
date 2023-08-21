//
//  ImportExport.swift
//  NuGoals
//
//  Created by John on 21/08/2023.
//

import Foundation

/// XXX tmp
enum Log {
    static func log(_ s: String) {
        print(s)
    }
}

struct AppGroupImportExport {
    let appGroup: String
    let filePrefix: String

    static let exportedSuffix = "exported"

    var appContainerURL: URL {
        try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    }

    var groupContainerURL: URL {
        guard let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            preconditionFailure("Can't get app group container URL.")
        }
        return url
    }

    private func matchingFiles(in url: URL) -> [URL] {
        var result: [URL] = []
        guard let enumerator = FileManager.default.enumerator(at: url, includingPropertiesForKeys: [], options: .skipsSubdirectoryDescendants) else {
            preconditionFailure("Can't enumerate path: \(url.path)")
        }
        while let fileURL = enumerator.nextObject() as? URL,
              case let filename = fileURL.lastPathComponent {
            if filename.hasPrefix(filePrefix) && !filename.hasSuffix(".\(Self.exportedSuffix)") {
                result.append(fileURL)
            }
        }
        return result
    }

    private func copy(fileURLs: [URL], to url: URL, suffix: String = "") {
        for fileURL in fileURLs {
            let destination = url.appendingPathComponent(fileURL.lastPathComponent)
                .appendingPathExtension(suffix)
            try? FileManager.default.removeItem(at: destination)
            try! FileManager.default.copyItem(at: fileURL, to: destination)
        }
    }

    private func delete(fileURLs: [URL]) {
        for fileURL in fileURLs {
            try? FileManager.default.removeItem(at: fileURL)
        }
    }

    init(appGroup: String, filePrefix: String) {
        self.appGroup = appGroup
        self.filePrefix = filePrefix
    }

    func checkForImport() {
        Log.log("Import - app group container \(groupContainerURL.path)")
        Log.log("Import - app container \(appContainerURL.path)")
        guard case let fileURLs = matchingFiles(in: appContainerURL), !fileURLs.isEmpty else {
            Log.log("Import - no app group file import required")
            return
        }
        copy(fileURLs: fileURLs, to: groupContainerURL)
        delete(fileURLs: fileURLs)
        Log.log("Import - imported files into app group container: \(fileURLs.map(\.lastPathComponent))")
    }

    func export() {
        Log.log("Export - app group container \(groupContainerURL.path)")
        Log.log("Export - app container \(appContainerURL.path)")
        guard case let fileURLs = matchingFiles(in: groupContainerURL), !fileURLs.isEmpty else {
            Log.log("Export - no app group export required")
            return
        }
        copy(fileURLs: fileURLs, to: appContainerURL, suffix: Self.exportedSuffix)
        Log.log("Export - exported files: \(fileURLs.map(\.lastPathComponent))")
    }
}
