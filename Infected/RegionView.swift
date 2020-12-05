//
//  RegionView.swift
//  Infected
//
//  Created by marko on 9/26/20.
//

import SwiftUI

struct RegionView: View {

    @State private var isOnWatchlist: Bool

    let summary: Summary
    let watchlistKeeper: WatchlistKeeper
    let showWatchlistStatus: Bool

    init(summary: Summary,
         watchlistKeeper: WatchlistKeeper = WatchlistKeeper(),
         showWatchlistStatus: Bool = true) {
        self.summary = summary
        self.watchlistKeeper = watchlistKeeper
        self.showWatchlistStatus = showWatchlistStatus

        let isOnWathlistInitialValue = watchlistKeeper.isRegionOnWatchlist(regionCode: summary.regionCode)
        _isOnWatchlist = State(initialValue: isOnWathlistInitialValue)
    }

    var body: some View {
        Section(header: SectionHeader(summary: summary)) {
            RowView(representation: .cases, numbers: summary.positiveCases)
            RowView(representation: .hospitalizations, numbers: summary.hospitalAdmissions)
            RowView(representation: .deaths, numbers: summary.deaths)
            if showWatchlistStatus {
                if isOnWatchlist {
                    HStack {
                        Image(systemName: "checkmark")
                        Text("On Watchlist")
                    }
                    .foregroundColor(.secondary)
                    .font(.subheadline)
                } else {
                    Button(action: addToWatchlistSelected, label: {
                        Text("Add to Watchlist")
                    })
                    .font(.headline)
                    .foregroundColor(.blue)
                }
            }
        }
        .textCase(.none)
    }

    private func addToWatchlistSelected() {
        let regionCode = summary.regionCode
        watchlistKeeper.add(regionCode: regionCode)
        isOnWatchlist = watchlistKeeper.isRegionOnWatchlist(regionCode: regionCode)
    }

}

#if DEBUG
struct DaySectionView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            RegionView(summary: .random)
            RegionView(summary: .demo)
        }
        .listStyle(InsetGroupedListStyle())
        .previewLayout(.sizeThatFits)
    }
}
#endif
