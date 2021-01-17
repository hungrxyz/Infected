//
//  RegionView.swift
//  Infected
//
//  Created by marko on 9/26/20.
//

import SwiftUI

struct RegionView: View {

    @EnvironmentObject var numbersProvider: NumbersProvider
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
            RowView(
                representation: .cases,
                numbers: summary.positiveCases,
                occupancy: nil,
                vaccinations: nil
            )
            if let hospitalOccupancy = summary.hospitalOccupancy {
                RowView(
                    representation: .hospitalOccupancy,
                    numbers: nil,
                    occupancy: hospitalOccupancy,
                    vaccinations: nil
                )
            } else {
                RowView(
                    representation: .hospitalizations,
                    numbers: summary.hospitalAdmissions,
                    occupancy: nil,
                    vaccinations: nil
                )
            }
            if let intensiveCareOccupancy = summary.intensiveCareOccupancy {
                RowView(
                    representation: .intensiveCareOccupancy,
                    numbers: nil,
                    occupancy: intensiveCareOccupancy,
                    vaccinations: nil
                )
            }
            RowView(
                representation: .deaths,
                numbers: summary.deaths,
                occupancy: nil,
                vaccinations: nil
            )
            if let vaccinations = summary.vaccinations {
                RowView(
                    representation: .vaccinations,
                    numbers: nil,
                    occupancy: nil,
                    vaccinations: vaccinations
                )
            }
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
        numbersProvider.reloadWatchlistRegions()
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
