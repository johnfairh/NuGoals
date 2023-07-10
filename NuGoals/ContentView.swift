//
//  ContentView.swift
//  NuGoals
//
//  Created by John on 26/06/2023.
//

import SwiftUI
import SwiftData

import Foundation

struct ContentView: View {
    @Environment(\.modelContext) var modelContext: ModelContext

    @Query(sort: \.sortOrder) var allGoals: [CoreDataSchema.Goal]
    @Query(sort: \.sortOrder) var allAlarms: [CoreDataSchema.Alarm]
    @Query(sort: \.sortOrder) var allEpochs: [CoreDataSchema.Epoch]
    @Query(sort: \.dayStamp) var allNotes: [CoreDataSchema.Note]
    @Query(sort: \.sortOrder) var allIcons: [CoreDataSchema.Icon]

    @State var containerText: String = ""

    var body: some View {
        VStack {
            Text("Total goals: \(allGoals.count)")
            Text("Total alarms: \(allAlarms.count)")
            Text("Total epochs: \(allEpochs.count)")
            Text("Total notes: \(allNotes.count)")
            Text("Total icons: \(allIcons.count)")
            Divider()
            Text(containerText)
                .selectionDisabled(false)
            Divider()
            Button() {
//                var fetchDesc: FetchDescriptor<Goal> = FetchDescriptor(sortBy: [
//                    SortDescriptor(\.sortOrder, order: .reverse)
//                ])
//                fetchDesc.fetchLimit = 1
//                fetchDesc.propertiesToFetch = [\.sortOrder]
//
//                let results = try! modelContext.fetch(fetchDesc)
//                print(results[0].sortOrder)
//                let newSortOrder = results[0].sortOrder + 1
//
//                let goal = Goal(name: "New Goal", sortOrder: UInt64(newSortOrder))
//                modelContext.insert(goal)
                let container = modelContext.container
                let config = container.configurations.first!
                let idURL = config.id
                let name = config.name ?? "(unnamed)"

                let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first?.absoluteString ?? "(none)"
                containerText = "URL: \(idURL)\nname: \(name)\nappSupport: \(appSupport)"

            } label: {
                Text("Report")
            }
            List {
                ForEach(allIcons) { icon in
                    HStack {
                        Text(icon.name + " \(icon.usingGoals.count) \(icon.usingAlarms.count)")
//                        Image(uiImage: UIImage(data: icon.imageData)!)
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
        .previewLayout(.sizeThatFits)
}

