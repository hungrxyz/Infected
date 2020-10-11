//
//  DaySectionView.swift
//  Infected
//
//  Created by marko on 9/26/20.
//

import SwiftUI

struct DaySectionView: View {

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()

    let numbers: LatestNumbers

    var body: some View {
        Section(header: Text(Self.dateFormatter.string(from: numbers.date))) {
            RowView(captionText: "New Cases",
                    value: numbers.cases,
                    diffValue: numbers.casesDifference)
            RowView(captionText: "Hospitalizations",
                    value: numbers.hospitalizations,
                    diffValue: numbers.hospitalizationsDifference)
            RowView(captionText: "Deaths",
                    value: numbers.deaths,
                    diffValue: numbers.deathsDifference)
        }
    }
}

struct DaySectionView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            DaySectionView(numbers: .demo)
        }
        .listStyle(InsetGroupedListStyle())
        .previewLayout(.sizeThatFits)
    }
}
