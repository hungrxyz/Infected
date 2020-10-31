//
//  RowView.swift
//  Infected
//
//  Created by marko on 9/27/20.
//

import SwiftUI

struct RowView: View {

    private static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    let numbersKindText: String
    let dailyNumber: Int
    let totalNumber: Int
    let trendNumber: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(numbersKindText)
                .font(.system(.headline, design: .rounded))
                .foregroundColor(.primary)
            VStack(alignment: .leading) {
                HStack(alignment: .lastTextBaseline) {
                    Text(Self.numberFormatter.string(for: dailyNumber) ?? "--")
                        .font(.system(.title, design: .rounded)).bold()
                    TrendNumberView(trendNumber: trendNumber)
                    Spacer()
                }
                Text("New")
                    .foregroundColor(.secondary)
            }
            VStack(alignment: .leading) {
                Text(Self.numberFormatter.string(for: totalNumber) ?? "--")
                    .font(.system(.title, design: .rounded)).bold()
                Text("Total")
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
    }

}

struct RowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RowView(numbersKindText: "Cases", dailyNumber: Int.random(in: 0...9999), totalNumber: Int.random(in: 0...Int.max), trendNumber: Int.random(in: -9999...9999))
                .preferredColorScheme(.dark)
            RowView(numbersKindText: "Cases", dailyNumber: Int.random(in: 0...9999), totalNumber: Int.random(in: 0...Int.max), trendNumber: Int.random(in: -9999...9999))
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
