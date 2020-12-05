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
            WatchlistView()
                .navigationBarItems(trailing: aboutButton)
                .sheet(isPresented: $isAboutShown, content: {
                    AboutView()
                })
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: numbersProvider.reloadAllRegions)
        .onReceive(willEnterForegroundPublisher, perform: numbersProvider.reloadAllRegions)
    }

    private struct WatchlistView: View {

        private static let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .medium
            formatter.doesRelativeDateFormatting = true
            return formatter
        }()

        @EnvironmentObject var numbersProvider: NumbersProvider

        var body: some View {
            if let watchlist = numbersProvider.watchlistSummaries {
                List {
                    if let dateString = Self.dateFormatter.string(from: watchlist.updatedAt) {
                        let displayString = [
                            NSLocalizedString("Last updated", comment: ""),
                            dateString
                        ].joined(separator: " ")
                        Text(displayString)
                            .font(.callout)
                            .foregroundColor(.secondary)
                    }
                    ForEach(watchlist.regions) { summary in
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
                }
                .listStyle(InsetGroupedListStyle())
                .navigationBarTitle("Watchlist")
            } else {
                Text("No latest numbers")
            }
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
