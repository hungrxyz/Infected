//
//  RegionView.swift
//  Infected
//
//  Created by marko on 9/26/20.
//

import SwiftUI

struct RegionView: View {

    @State private var isOnWatchlist: Bool = true

    let summary: Summary
    let showWatchlistStatus: Bool

    init(summary: Summary, showWatchlistStatus: Bool = true) {
        self.summary = summary
        self.showWatchlistStatus = showWatchlistStatus
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
                    .font(.subheadline)
                } else {
                    Button(action: { print("Add me up") }, label: {
                        Text("Add to Watchlist")
                    })
                    .font(.headline)
                    .foregroundColor(.blue)
                }
            }
        }
        .textCase(.none)
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
