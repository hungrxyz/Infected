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

    @State private var isInfoSheetShown = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                representation.image
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
            HStack(alignment: .top, spacing: 8) {
                if let numbers = numbers {
                    switch representation {
                    case .vaccinations:
                        VaccinationsView(vaccinations: numbers)
                    default:
                        DefaultNumbersView(numbers: numbers)
                    }
                } else if let occupancy = occupancy {
                    OccupancyView(occupancy: occupancy)
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
                .font(.footnote)
                .foregroundColor(.secondary)
                .lineLimit(1)
        }

    }

    private enum NumberStyle {
        case integer
        case decimal
        case percent
    }

    private struct DataPointView: View {

        let titleKey: LocalizedStringKey
        let number: Float?
        let trend: Int?
        let numberStyle: NumberStyle

        var body: some View {
            VStack(alignment: .leading) {
                HeadlineView(text: titleKey)
                HStack(alignment: .lastTextBaseline, spacing: 4) {
                    NumberView(number: number, style: numberStyle)
                        .layoutPriority(10)
                    if let trendNumber = trend {
                        TrendNumberView(number: trendNumber)
                            .layoutPriority(9)
                    }
                }
            }
        }

    }

    private struct DataPointDateView: View {

        private static let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .none
            formatter.doesRelativeDateFormatting = true
            return formatter
        }()

        let titleKey: LocalizedStringKey
        let date: Date

        var body: some View {
            VStack(alignment: .leading) {
                HeadlineView(text: titleKey)
                Text(Self.dateFormatter.string(from: date))
                    .font(.system(.title3, design: .rounded)).bold()
            }
        }

    }

    private struct NumberView: View {

        private static let numberFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.minimumIntegerDigits = 1
            formatter.maximumFractionDigits = 1
            return formatter
        }()

        private static let percentNumberFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .percent
            formatter.minimumIntegerDigits = 1
            formatter.maximumFractionDigits = 1
            return formatter
        }()

        let number: Float?
        let style: NumberStyle

        init(number: Float?, style: NumberStyle) {
            self.number = number
            self.style = style
        }

        var numberString: String {
            guard let number = number else {
                return "--"
            }
            switch style {
            case .integer, .decimal:
                return Self.numberFormatter.string(for: number) ?? "--"
            case .percent:
                return Self.percentNumberFormatter.string(for: number) ?? "--"
            }
        }

        var body: some View {
            Text(numberString)
                .font(.system(.title3, design: .rounded)).bold()
        }

    }

    private struct DefaultNumbersView: View {
        let numbers: SummaryNumbers

        var body: some View {
            DataPointView(
                titleKey: "New",
                number: numbers.new.flatMap(Float.init),
                trend: numbers.trend,
                numberStyle: .integer
            )
            .layoutPriority(10)
            Divider()
            if let per100K = numbers.per100KInhabitants {
                DataPointView(
                    titleKey: "Per 100k",
                    number: per100K,
                    trend: nil,
                    numberStyle: .decimal
                )
                Divider()
            }
            DataPointView(
                titleKey: "Total",
                number: numbers.total.flatMap(Float.init),
                trend: nil,
                numberStyle: .integer
            )
        }

    }

    private struct OccupancyView: View {
        let occupancy: Occupancy

        var body: some View {
            DataPointView(
                titleKey: "New",
                number: occupancy.newAdmissions.flatMap(Float.init),
                trend: occupancy.newAdmissionsTrend,
                numberStyle: .integer
            )
            .layoutPriority(10)
            Divider()
            if let per100K = occupancy.newAdmissionsPer100KInhabitants {
                DataPointView(
                    titleKey: "Per 100k",
                    number: per100K,
                    trend: nil,
                    numberStyle: .decimal
                )
                Divider()
            }
            DataPointView(
                titleKey: "Occupied Beds",
                number: occupancy.currentlyOccupied.flatMap(Float.init),
                trend: occupancy.currentlyOccupiedTrend,
                numberStyle: .integer
            )
        }
    }

    private struct VaccinationsView: View {
        let vaccinations: SummaryNumbers

        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    if let new = vaccinations.new {
                        DataPointView(
                            titleKey: "New",
                            number: Float(new),
                            trend: nil,
                            numberStyle: .integer
                        )
                        .layoutPriority(9)
                        Divider()
                    }
                    DataPointView(
                        titleKey: "Total",
                        number: vaccinations.total.flatMap(Float.init),
                        trend: nil,
                        numberStyle: .integer
                    )
                    .layoutPriority(10)
                    Divider()
                    DataPointView(
                        titleKey: "Coverage",
                        number: vaccinations.percentageOfPopulation,
                        trend: nil,
                        numberStyle: .percent
                    )
                }
                if let estimatedDate = vaccinations.herdImmunityEstimatedDate {
                    DataPointDateView(titleKey: "Herd Immunity (Estimated)", date: estimatedDate)
                }
                if let currentTrendDate = vaccinations.herdImmunityCurrentTrendDate {
                    DataPointDateView(titleKey: "Herd Immunity (Current Trend)", date: currentTrendDate)
                }
            }
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

    var image: Image {
        switch self {
        case .cases:
            return Image(systemName: "plus.rectangle.fill.on.folder.fill")
        case .hospitalizations, .hospitalOccupancy:
            return Image(systemName: "cross.fill")
        case .intensiveCareOccupancy:
            return Image(systemName: "waveform.path.ecg.rectangle.fill")
        case .deaths:
            return Image("heart.broken.fill")
        case .vaccinations:
            return Image("syringe")
        }
    }

}

#if DEBUG
struct RowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RowView(
                representation: .cases,
                numbers: .demo,
                occupancy: nil
            )
            .preferredColorScheme(.dark)
            RowView(
                representation: .vaccinations,
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
