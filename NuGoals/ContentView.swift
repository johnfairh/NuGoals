//
//  ContentView.swift
//  NuGoals
//

import SwiftUI
import SwiftData

import Foundation

struct ContentView1: View {
    @State private var users = ["Paul", "Taylor", "Adele"]

    var body: some View {
        NavigationStack {
            List {
                ForEach(users, id: \.self) { user in
                    Text(user)
                }
                .onMove(perform: move)
            }
        }
    }

    func move(from source: IndexSet, to destination: Int) {
        users.move(fromOffsets: source, toOffset: destination)
    }
}

struct ContentView: View {
    @Environment(\.modelContext) var modelContext: ModelContext

    @Query(sort: \.sortOrder) var allGoals: [Goal]
    @Query(sort: \.sortOrder) var allAlarms: [Alarm]
    @Query(sort: \.startDate) var allEpochs: [Epoch]
    @Query(sort: \.creationDate) var allNotes: [Note]
    @Query(sort: \.sortOrder) var allIcons: [Icon]

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
                ForEach(allNotes.grouped(by: \.dayStamp).reversed()) { notes in
                    Section(header: Text(notes.groupID)) {
                        ForEach(notes.group) { note in
                            Text(note.text)
                        }
                    }
                }
            }
            .listSectionSpacing(.compact)
            .listStyle(.plain)
        }
        .padding()
    }
}

#Preview {
    ContentView()
        .previewLayout(.sizeThatFits)
}

