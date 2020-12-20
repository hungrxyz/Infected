//
//  RowView.swift
//  Infected
//
//  Created by marko on 9/27/20.
//

import SwiftUI

struct RowView: View {

    let representation: NumberRepresentation
    let numbers: SummaryNumbers?
    let occupancy: Occupancy?

    @State private var isInfoShown = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                switch representation {
                case .deaths:
                    Image(representation.symbolName)
                default:
                    Image(systemName: representation.symbolName)
                }
                Text(representation.displayNameLocalizedStringKey)
                if occupancy != nil {
                    Spacer()
                    Image(systemName: "info.circle")
                        .onTapGesture { isInfoShown.toggle() }
                        .foregroundColor(.blue)
                }
            }
            .font(.system(.headline, design: .rounded))
            .foregroundColor(.secondary)
            .sheet(isPresented: $isInfoShown, content: {
                NationalHospitalInfoView()
            })
            HStack(alignment: .top) {
                if let numbers = numbers {
                    DataPointView(
                        titleKey: "New",
                        number: numbers.new ?? -1,
                        trend: numbers.trend
                    )
                    .layoutPriority(10)
                    Divider()
                    DataPointView(
                        titleKey: "Total",
                        number: numbers.total ?? -1,
                        trend: nil
                    )
                    Spacer()
                } else if let occupancy = occupancy {
                    DataPointView(
                        titleKey: "New",
                        number: occupancy.newAdmissions ?? -1,
                        trend: occupancy.newAdmissionsTrend
                    )
                    .layoutPriority(10)
                    Divider()
                    DataPointView(
                        titleKey: "Occupied Beds",
                        number: occupancy.currentlyOccupied ?? -1,
                        trend: occupancy.currentlyOccupiedTrend
                    )
                    Spacer()
                }
            }
        }
        .padding(.vertical, 8)
    }

    private struct HeadlineView: View {

        let text: LocalizedStringKey

        var body: some View {
            Text(text)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }

    }

    private struct DataPointView: View {

        let titleKey: LocalizedStringKey
        let number: Int
        let trend: Int?

        var body: some View {
            VStack(alignment: .leading) {
                HeadlineView(text: titleKey)
                HStack(alignment: .lastTextBaseline) {
                    NumberView(number: number)
                        .layoutPriority(10)
                    if let trendNumber = trend {
                        TrendNumberView(number: trendNumber)
                            .layoutPriority(9)
                    }
                }
            }
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
        case .hospitalizations, .hospitalOccupancy:
            return "Hospitalizations"
        case .intensiveCareOccupancy:
            return "Intensive Care"
        case .deaths:
            return "Deaths"
        }
    }

    var symbolName: String {
        switch self {
        case .cases:
            return "plus.rectangle.fill.on.folder.fill"
        case .hospitalizations, .hospitalOccupancy:
            return "cross.fill"
        case .intensiveCareOccupancy:
            return "waveform.path.ecg.rectangle.fill"
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
                numbers: .random,
                occupancy: nil
            )
            .preferredColorScheme(.dark)
            RowView(
                representation: .hospitalizations,
                numbers: .random,
                occupancy: nil
            )
            RowView(
                representation: .intensiveCareOccupancy,
                numbers: nil,
                occupancy: .random
            )
        }
        .previewLayout(.fixed(width: 350.0, height: 160))
        .padding()
    }
}
#endif
