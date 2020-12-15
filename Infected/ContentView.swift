//
//  ContentView.swift
//  Infected
//
//  Created by marko on 9/19/20.
//

import SwiftUI

struct ContentView: View {

    @EnvironmentObject var numbersProvider: NumbersProvider
    @State var isAboutShown = false
    @State var editMode = EditMode.inactive

    private var aboutButton: some View {
        Button(action: {
            isAboutShown.toggle()
        }, label: {
            Image("virus")
                .imageScale(.large)
        })
    }

    private let willEnterForegroundPublisher = NotificationCenter.default
        .publisher(for: UIApplication.willEnterForegroundNotification)
        .map { _ in }

    var body: some View {
        NavigationView {
            if let watchlist = numbersProvider.watchlistSummaries {
                WatchlistView(editMode: $editMode,
                              lastUpdated: watchlist.updatedAt)
                    .navigationBarItems(leading: EditButton(), trailing: aboutButton)
                    .environment(\.editMode, $editMode)
                    .sheet(isPresented: $isAboutShown, content: {
                        AboutView()
                    })
            } else {
                HStack(spacing: 8) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                    Text("Loading...")
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: numbersProvider.reloadAllRegions)
        .onReceive(willEnterForegroundPublisher, perform: numbersProvider.reloadAllRegions)
    }

    private struct WatchlistView: View {

        private static let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            formatter.doesRelativeDateFormatting = true
            return formatter
        }()

        private let watchlistKeeper = WatchlistKeeper()

        @EnvironmentObject var numbersProvider: NumbersProvider
        @Binding var editMode: EditMode
        let lastUpdated: Date?

        var body: some View {
            List {
                switch editMode {
                case .inactive:
                    if let dateString = lastUpdated.flatMap(Self.dateFormatter.string) {
                        let displayString = [
                            NSLocalizedString("Last updated", comment: ""),
                            dateString
                        ].joined(separator: " ")
                        Text(displayString)
                            .font(.callout)
                            .foregroundColor(.secondary)
                    }
                    ForEach(numbersProvider.watchedSummaries) { summary in
                        RegionView(summary: summary, showWatchlistStatus: false)
                    }
                    NavigationLink(
                        destination: AllRegionsView(
                            national: numbersProvider.nationalSummary,
                            provinces: numbersProvider.provincialSummaries?.regions ?? [],
                            securityRegions: numbersProvider.securityRegionsSummaries?.regions ?? [],
                            municipalities: numbersProvider.municipalSummaries?.regions ?? []
                        )
                    ) {
                        Text("All Regions")
                    }
                default:
                    ForEach(numbersProvider.watchedSummaries) { summary in
                        Text(summary.regionName)
                    }
                    .onMove(perform: onMove)
                    .onDelete(perform: onDelete)
                }

            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("Watchlist")
        }

        private func onMove(source: IndexSet, destination: Int) {
            numbersProvider.watchedSummaries.move(fromOffsets: source, toOffset: destination)
            updateWatchlist()
        }

        private func onDelete(offsets: IndexSet) {
            numbersProvider.watchedSummaries.remove(atOffsets: offsets)
            updateWatchlist()
        }

        private func updateWatchlist() {
            let regionCodes = numbersProvider.watchedSummaries.map(\.regionCode)
            watchlistKeeper.replaceList(newRegionsCodes: regionCodes)
        }

    }

}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            ContentView()
        }
        .previewDevice("iPhone 12 mini")
    }
}

private extension NumbersProvider {

    static var demo: NumbersProvider {
        let provider = NumbersProvider()
        provider.nationalSummary = .demo
        return provider
    }

}
#endif
