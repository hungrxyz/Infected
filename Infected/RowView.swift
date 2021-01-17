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
    let vaccinations: Vaccinations?

    @State private var isInfoSheetShown = false

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
                if occupancy != nil || representation == .hospitalizations {
                    Spacer()
                    Image(systemName: "info.circle")
                        .onTapGesture { isInfoSheetShown.toggle() }
                        .foregroundColor(.blue)
                }
            }
            .font(.system(.headline, design: .rounded))
            .foregroundColor(.secondary)
            .sheet(isPresented: $isInfoSheetShown, content: {
                switch representation {
                case .hospitalizations:
                    HospitalAdmissionsInfoView()
                case .hospitalOccupancy, .intensiveCareOccupancy:
                    NationalHospitalInfoView()
                default:
                    fatalError()
                }
            })
            HStack(alignment: .top) {
                if let numbers = numbers {
                    DefaultNumbersView(numbers: numbers)
                } else if let occupancy = occupancy {
                    OccupancyView(occupancy: occupancy)
                } else if let vaccinations = vaccinations {
                    VaccinationsView(vaccinations: vaccinations)
                }
                Spacer()
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

    private struct PercentDataPointView: View {

        let titleKey: LocalizedStringKey
        let number: Float
        let trend: Int?

        var body: some View {
            VStack(alignment: .leading) {
                HeadlineView(text: titleKey)
                HStack(alignment: .lastTextBaseline) {
                    PercentNumberView(number: number)
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

    private struct PercentNumberView: View {

        private static let numberFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .percent
            formatter.minimumIntegerDigits = 1
            formatter.maximumFractionDigits = 1
            return formatter
        }()

        let number: Float?

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

    private struct DefaultNumbersView: View {
        let numbers: SummaryNumbers

        var body: some View {
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
        }

    }

    private struct OccupancyView: View {
        let occupancy: Occupancy

        var body: some View {
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
        }
    }

    private struct VaccinationsView: View {
        let vaccinations: Vaccinations

        var body: some View {
            if let new = vaccinations.new {
                DataPointView(
                    titleKey: "New",
                    number: new,
                    trend: nil
                )
                .layoutPriority(10)
                Divider()
            }
            DataPointView(
                titleKey: "Total",
                number: vaccinations.total ?? -1,
                trend: nil
            )
            .layoutPriority(8)
            Divider()
            PercentDataPointView(
                titleKey: "Coverage",
                number: vaccinations.percentageOfPopulation ?? -1,
                trend: nil
            )
            .layoutPriority(9)
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
        case .vaccinations:
            return "Vaccinations"
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
        case .vaccinations:
            return "heart.text.square.fill"
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
                occupancy: nil,
                vaccinations: nil
            )
            .preferredColorScheme(.dark)
            RowView(
                representation: .vaccinations,
                numbers: nil,
                occupancy: nil,
                vaccinations: .random
            )
            .preferredColorScheme(.dark)
            RowView(
                representation: .hospitalizations,
                numbers: .random,
                occupancy: nil,
                vaccinations: nil
            )
            RowView(
                representation: .intensiveCareOccupancy,
                numbers: nil,
                occupancy: .random,
                vaccinations: nil
            )
        }
        .previewLayout(.fixed(width: 350.0, height: 160))
        .padding()
    }
}
#endif
