//
//  RowView.swift
//  Infected
//
//  Created by marko on 9/27/20.
//

import SwiftUI

struct RowView: View {

    let representation: NumberRepresentation
    let numbers: SummaryNumbers

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
                    HeadlineView(text: "New")
                    NumberView(number: numbers.new)
                }
                .layoutPriority(10)
                Divider()
                VStack(alignment: .leading) {
                    HeadlineView(text: "Trend")
                    TrendNumberView(number: numbers.trend ?? 0)
                }
                .layoutPriority(9)
                Divider()
                VStack(alignment: .leading) {
                    HeadlineView(text: "Total")
                    NumberView(number: numbers.total)
                }
                Spacer()
            }
        }
        .padding(.vertical, 8)
    }

    private struct HeadlineView: View {

        let text: String

        var body: some View {
            Text(text)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }

    }

    private struct NumberView: View {

        private static let numberFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter
        }()

        let number: Int?

        var numberString: String {
            guard let number = number else {
                return "--"
            }
            return Self.numberFormatter.string(for: number) ?? "--"
        }

        var body: some View {
            Text(numberString)
                .font(.system(.title2, design: .rounded)).bold()
        }

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
                numbers: .random
            )
            .preferredColorScheme(.dark)
            RowView(
                representation: .hospitalizations,
                numbers: .random
            )
        }
        .previewLayout(.fixed(width: 350.0, height: 200))
        .padding()
    }
}
#endif
