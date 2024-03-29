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
    let vaccinations: Vaccinations?
    let occupancy: Occupancy?

    @State private var isInfoSheetShown = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                representation.image
                VStack(alignment: .leading) {
                    Text(representation.displayNameLocalizedStringKey)
                    if representation == .vaccinations, let lastUpdatedVaccinations = vaccinations?.lastUpdated {
                        VaccinationsUpdatedCaptionView(date: lastUpdatedVaccinations)
                    }
                }
                if representation.hasInfo {
                    Spacer(minLength: 0)
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
                case .homeAdmissions:
                    HomeAdmissionsInfoView()
                case .vaccinations:
                    VaccinationsInfoView()
                default:
                    fatalError()
                }
            })
            HStack(alignment: .top, spacing: 8) {
                if let numbers = numbers {
                    switch representation {
                    case .cases:
                        CasesNumbersView(numbers: numbers)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    default:
                        DefaultNumbersView(numbers: numbers)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                } else if let vaccinations = vaccinations {
                    VaccinationsView(vaccinations: vaccinations)
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else if let occupancy = occupancy {
                    OccupancyView(occupancy: occupancy, representation: representation)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
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
        case decimalExtendedFraction
        case percent
    }

    private struct DataPointView: View {

        let titleKey: LocalizedStringKey
        let number: Number?
        let trend: Int?
        let numberStyle: NumberStyle
        let isPositiveTrendUp: Bool

        var body: some View {
            VStack(alignment: .leading) {
                HeadlineView(text: titleKey)
                HStack(alignment: .lastTextBaseline, spacing: 4) {
                    NumberView(number: number, style: numberStyle)
                        .layoutPriority(100)
                    if let trendNumber = trend {
                        TrendNumberView(number: trendNumber, isPositiveUp: isPositiveTrendUp)
                            .layoutPriority(101)
                    }
                }
            }
        }

    }

    private struct DataPointDateView: View {

        private static let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
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

        private static let decimalExtendedFractionFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.minimumIntegerDigits = 1
            formatter.maximumFractionDigits = 2
            return formatter
        }()

        let number: Number?
        let style: NumberStyle

        init(number: Number?, style: NumberStyle) {
            self.number = number
            self.style = style
        }

        var numberString: String {
            guard let number = number else {
                return "--"
            }
            switch style {
            case .integer, .decimal:
                switch number {
                case let .integer(value):
                    return Self.numberFormatter.string(for: value) ?? "--"
                case let .decimal(value):
                    return Self.numberFormatter.string(for: value) ?? "--"
                }
            case .percent:
                return Self.percentNumberFormatter.string(for: number.floatValue) ?? "--"
            case .decimalExtendedFraction:
                return Self.decimalExtendedFractionFormatter.string(for: number.floatValue) ?? "--"
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
            HStack(spacing: 8) {
                DataPointView(
                    titleKey: "New",
                    number: numbers.new.flatMap { .integer($0) },
                    trend: numbers.trend,
                    numberStyle: .integer,
                    isPositiveTrendUp: false
                )
                .layoutPriority(10)
                Divider()
                if let per100K = numbers.per100KInhabitants {
                    DataPointView(
                        titleKey: "Per 100k",
                        number: .decimal(per100K),
                        trend: nil,
                        numberStyle: .decimal,
                        isPositiveTrendUp: false
                    )
                    Divider()
                }
                DataPointView(
                    titleKey: "Total",
                    number: numbers.total.flatMap { .integer($0) },
                    trend: nil,
                    numberStyle: .integer,
                    isPositiveTrendUp: false
                )
            }
        }

    }

    private struct CasesNumbersView: View {
        let numbers: SummaryNumbers

        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top) {
                    DataPointView(
                        titleKey: "New",
                        number: numbers.new.flatMap { Number.integer($0) },
                        trend: numbers.trend,
                        numberStyle: .integer,
                        isPositiveTrendUp: false
                    )
                    .layoutPriority(10)
                    if let per100K = numbers.per100KInhabitants {
                        Divider()
                        DataPointView(
                            titleKey: "Per 100k",
                            number: .decimal(per100K),
                            trend: nil,
                            numberStyle: .decimal,
                            isPositiveTrendUp: false
                        )
                    }
                    if numbers.percentageOfPopulation == nil {
                        Divider()
                        DataPointView(
                            titleKey: "Total",
                            number: numbers.total.flatMap { Number.integer($0) },
                            trend: nil,
                            numberStyle: .integer,
                            isPositiveTrendUp: false
                        )
                    }
                }
                if let reproductionNumber = numbers.percentageOfPopulation {
                    HStack {
                        DataPointView(
                            titleKey: "Total",
                            number: numbers.total.flatMap { Number.integer($0) },
                            trend: nil,
                            numberStyle: .integer,
                            isPositiveTrendUp: false
                        )
                        Divider()
                        DataPointView(
                            titleKey: "Reproduction Number",
                            number: .decimal(reproductionNumber),
                            trend: nil,
                            numberStyle: .decimalExtendedFraction,
                            isPositiveTrendUp: false
                        )
                    }
                }
            }

        }

    }

    private struct OccupancyView: View {
        let occupancy: Occupancy
        let representation: NumberRepresentation

        var body: some View {
            HStack(spacing: 8) {
                DataPointView(
                    titleKey: "New",
                    number: occupancy.newAdmissions.flatMap { Number.integer($0) },
                    trend: occupancy.newAdmissionsTrend,
                    numberStyle: .integer,
                    isPositiveTrendUp: false
                )
                .layoutPriority(10)
                Divider()
                DataPointView(
                    titleKey: representation == .homeAdmissions ? "Active" : "Occupied Beds",
                    number: occupancy.currentlyOccupied.flatMap { Number.integer($0) },
                    trend: occupancy.currentlyOccupiedTrend,
                    numberStyle: .integer,
                    isPositiveTrendUp: false
                )
                .layoutPriority(9)
                if let per100K = occupancy.currentlyOccupiedPer100KInhabitants {
                    Divider()
                    DataPointView(
                        titleKey: "Per 100k",
                        number: .decimal(per100K),
                        trend: nil,
                        numberStyle: .decimal,
                        isPositiveTrendUp: false
                    )
                    .layoutPriority(8)
                }
            }
        }
    }

    private struct VaccinationsView: View {
        let vaccinations: Vaccinations

        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    if let new = vaccinations.numbers.new {
                        DataPointView(
                            titleKey: "New Doses",
                            number: .integer(new),
                            trend: nil,
                            numberStyle: .integer,
                            isPositiveTrendUp: true
                        )
                        .layoutPriority(9)
                        Divider()
                    }
                    if let average = vaccinations.numbers.average {
                        DataPointView(
                            titleKey: "New (7 day average)",
                            number: .integer(average),
                            trend: vaccinations.numbers.trend,
                            numberStyle: .integer,
                            isPositiveTrendUp: true
                        )
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    DataPointView(
                        titleKey: "Total Doses",
                        number: vaccinations.numbers.total.flatMap { Number.integer($0) },
                        trend: nil,
                        numberStyle: .integer,
                        isPositiveTrendUp: true
                    )
                    .layoutPriority(10)
                    Divider()
                    DataPointView(
                        titleKey: "Coverage",
                        number: vaccinations.numbers.percentageOfPopulation.flatMap { Number.decimal($0) },
                        trend: nil,
                        numberStyle: .percent,
                        isPositiveTrendUp: true
                    )
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    if let estimatedDate = vaccinations.herdImmunityEstimatedDate {
                        DataPointDateView(titleKey: "Herd Immunity (Estimated)", date: estimatedDate)
                    }
                    if let currentTrendDate = vaccinations.herdImmunityCurrentTrendDate {
                        Divider()
                        DataPointDateView(titleKey: "Herd Immunity (Current Trend)", date: currentTrendDate)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
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
        case .homeAdmissions:
            return "Home Admissions"
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
        case .homeAdmissions:
            return Image(systemName: "house.fill")
        case .deaths:
            return Image("heart.broken.fill")
        case .vaccinations:
            return Image("syringe")
        }
    }

    var hasInfo: Bool {
        switch self {
        case .hospitalizations,
             .hospitalOccupancy,
             .intensiveCareOccupancy,
             .homeAdmissions,
             .vaccinations:
            return true
        default:
            return false
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
                vaccinations: nil,
                occupancy: nil
            )
            .preferredColorScheme(.dark)
            RowView(
                representation: .vaccinations,
                numbers: nil,
                vaccinations: Summary.demo.vaccinations,
                occupancy: nil
            )
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: 350.0, height: 300))
            RowView(
                representation: .hospitalizations,
                numbers: .random,
                vaccinations: nil,
                occupancy: nil
            )
            RowView(
                representation: .homeAdmissions,
                numbers: nil,
                vaccinations: nil,
                occupancy: .random
            )
        }
        .previewLayout(.fixed(width: 350.0, height: 160))
        .padding()
    }
}
#endif
