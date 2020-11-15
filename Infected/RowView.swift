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

    let representation: NumberRepresentation
    let dailyNumber: Int
    let totalNumber: Int
    let trendNumber: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                switch representation {
                case .deaths:
                    Image(representation.symbolName)
                default:
                    Image(systemName: representation.symbolName)
                }
                Text(representation.displayNameLocalizedStringKey)
            }
            .font(.system(.headline, design: .rounded))
            .foregroundColor(.secondary)
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("New")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(Self.numberFormatter.string(for: dailyNumber) ?? "--")
                        .font(.system(.title2, design: .rounded)).bold()
                }
                Divider()
                VStack(alignment: .leading) {
                    Text("Trend")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    TrendNumberView(trendNumber: trendNumber)
                }
                Divider()
                VStack(alignment: .leading) {
                    Text("Total")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(Self.numberFormatter.string(for: totalNumber) ?? "--")
                        .font(.system(.title2, design: .rounded)).bold()
                }
                Spacer()
            }
        }
        .padding(.vertical, 8)
    }

}

private extension NumberRepresentation {

    var displayNameLocalizedStringKey: LocalizedStringKey {
        switch self {
        case .cases:
            return "Cases"
        case .hospitalizations:
            return "Hospitalizations"
        case .deaths:
            return "Deaths"
        }
    }

    var symbolName: String {
        switch self {
        case .cases:
            return "folder.fill.badge.plus"
        case .hospitalizations:
            return "cross.case.fill"
        case .deaths:
            return "heart.broken.fill"
        }
    }

}

#if DEBUG
struct RowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RowView(
                representation: .cases,
                dailyNumber: Int.random(in: 0...9999),
                totalNumber: Int.random(in: 0...9999999),
                trendNumber: Int.random(in: -9999...9999)
            )
            .preferredColorScheme(.dark)
            RowView(
                representation: .hospitalizations,
                dailyNumber: Int.random(in: 0...9999),
                totalNumber: Int.random(in: 0...9999999),
                trendNumber: Int.random(in: -9999...9999)
            )
        }
        .previewLayout(.fixed(width: 350.0, height: 200))
        .padding()
    }
}
#endif
