//
//  DaySectionView.swift
//  Infected
//
//  Created by marko on 9/26/20.
//

import SwiftUI

struct DaySectionView: View {

    let area: Area

    var body: some View {
        Section(header: Header(text: area.name)) {
            RowView(captionText: "New Cases",
                    value: area.latest.cases,
                    diffValue: area.casesDifferenceToPreviousDay)
            RowView(captionText: "Hospitalizations",
                    value: area.latest.hospitalizations,
                    diffValue: area.hospitalizationsDifferenceToPreviousDay)
            RowView(captionText: "Deaths",
                    value: area.latest.deaths,
                    diffValue: area.deathsDifferenceToPreviousDay)
        }
        .textCase(.none)
    }

    struct Header: View {
        let text: String

        var body: some View {
            Text(text.capitalized)
                .font(.headline)
                .foregroundColor(.primary)
                .position(x: 33, y: 12)
        }
    }

}

struct DaySectionView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            DaySectionView(area: NationalNumbers.demo)
        }
        .listStyle(InsetGroupedListStyle())
        .previewLayout(.sizeThatFits)
    }
}
