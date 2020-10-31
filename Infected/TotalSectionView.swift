//
//  TotalSectionView.swift
//  Infected
//
//  Created by marko on 9/27/20.
//

import SwiftUI

struct TotalSectionView: View {

    let numbers: LatestNumbers

    var body: some View {
        Section(header: Text("Total")) {
//            RowView(captionText: "New Cases",
//                    value: numbers.totalCases,
//                    diffValue: nil)
//            RowView(captionText: "Hospitalizations",
//                    value: numbers.totalHospitalizations,
//                    diffValue: nil)
//            RowView(captionText: "Deaths",
//                    value: numbers.totalDeaths,
//                    diffValue: nil)
        }
    }
}

struct TotalSectionView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            TotalSectionView(numbers: .demo)
        }
        .listStyle(InsetGroupedListStyle())
        .previewLayout(.sizeThatFits)
    }
}
