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

    let numbers: DailyNumbers

    var body: some View {
        Section(header: Text(Self.dateFormatter.string(from: numbers.date))) {
            RowView(imageName: "plus",
                    captionText: "New cases",
                    value: numbers.diagnosed)
            RowView(imageName: "bed.double",
                    captionText: "Hospitalized",
                    value: numbers.hospitalized)
            RowView(imageName: "xmark",
                    captionText: "Deceased",
                    value: numbers.deceased)
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
