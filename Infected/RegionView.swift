//
//  RegionView.swift
//  Infected
//
//  Created by marko on 9/26/20.
//

import SwiftUI

struct RegionView: View {

    let summary: Summary

    var body: some View {
        Section(header: SectionHeader(summary: summary)) {
            RowView(
                representation: .cases,
                numbers: summary.positiveCases
            )
            RowView(
                representation: .hospitalizations,
                numbers: summary.hospitalAdmissions
            )
            RowView(
                representation: .deaths,
                numbers: summary.deaths
            )
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
