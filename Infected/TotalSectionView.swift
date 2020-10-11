//
//  TotalSectionView.swift
//  Infected
//
//  Created by marko on 9/27/20.
//

import SwiftUI

struct TotalSectionView: View {

    let numbers: DailyNumbers

    var body: some View {
        Section(header: Text("Total")) {
            RowView(imageName: "number",
                    captionText: "Cases",
                    value: numbers.totalDiagnosed)
            RowView(imageName: "bed.double",
                    captionText: "Hospitalized",
                    value: numbers.totalHospitalized)
            RowView(imageName: "xmark",
                    captionText: "Deceased",
                    value: numbers.totalDeceased)
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
