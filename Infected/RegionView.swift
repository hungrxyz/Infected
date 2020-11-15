//
//  RegionView.swift
//  Infected
//
//  Created by marko on 9/26/20.
//

import SwiftUI

struct RegionView: View {

    let region: Region

    var body: some View {
        Section(header: SectionHeader(text: region.name)) {
            RowView(
                representation: .cases,
                dailyNumber: region.latest.cases ?? 0,
                totalNumber: region.total.cases ?? 0,
                trendNumber: region.casesDifferenceToPreviousDay ?? 0
            )
            RowView(
                representation: .hospitalizations,
                dailyNumber: region.latest.hospitalizations ?? 0,
                totalNumber: region.total.hospitalizations ?? 0,
                trendNumber: region.hospitalizationsDifferenceToPreviousDay ?? 0
            )
            RowView(
                representation: .deaths,
                dailyNumber: region.latest.deaths ?? 0,
                totalNumber: region.total.deaths ?? 0,
                trendNumber: region.deathsDifferenceToPreviousDay ?? 0
            )
        }
        .textCase(.none)
    }

}

#if DEBUG
struct DaySectionView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            RegionView(region: NationalNumbers.random)
            RegionView(region: NationalNumbers.demo)
        }
        .listStyle(InsetGroupedListStyle())
        .previewLayout(.sizeThatFits)
    }
}
#endif
