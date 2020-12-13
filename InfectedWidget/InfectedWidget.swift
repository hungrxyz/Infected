//
//  InfectedWidget.swift
//  InfectedWidget
//
//  Created by marko on 9/20/20.
//

import WidgetKit
import SwiftUI
import Combine

final class Provider: TimelineProvider {

    private var cancellables = Set<AnyCancellable>()

    private var numbersProvider: NumbersProvider?

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), summary: .dummyNumbers)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), summary: .dummyNumbers)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {

        numbersProvider = NumbersProvider()
        
        numbersProvider?.$nationalSummary
            .filter { $0 != nil }
            .sink { completion in
                print(completion)
            } receiveValue: { [weak self] summary in
                let now = Date()
                let entry = SimpleEntry(date: now, summary: summary!)

                let after1Hour = Calendar.current.date(byAdding: .hour, value: 1, to: now)!

                let timeline = Timeline(entries: [entry], policy: .after(after1Hour))
                
                self?.numbersProvider = nil

                completion(timeline)
            }.store(in: &cancellables)

        numbersProvider?.reloadNational()
    }

}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let summary: Summary
}

struct InfectedWidgetEntryView : View {

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()

    var entry: Provider.Entry

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("NL - \(Self.dateFormatter.string(from: entry.summary.updatedAt ?? Date()))")
                    .font(Font.system(size: 14, weight: .semibold))
                    .foregroundColor(.secondary)
                NumbersView(
                    numberRepresentation: .cases,
                    latestNumber: entry.summary.positiveCases.new ?? -1,
                    trendNumber: entry.summary.positiveCases.trend ?? 0
                )
                if let hospitalOccupancy = entry.summary.hospitalOccupancy {
                    NumbersView(
                        numberRepresentation: .hospitalOccupancy,
                        latestNumber: hospitalOccupancy.newAdmissions ?? -1,
                        trendNumber: hospitalOccupancy.newAdmissionsTrend ?? 0
                    )
                } else {
                    NumbersView(
                        numberRepresentation: .hospitalizations,
                        latestNumber: entry.summary.hospitalAdmissions.new ?? -1,
                        trendNumber: entry.summary.hospitalAdmissions.trend ?? 0
                    )
                }
                if let intensiveCareOccupancy = entry.summary.intensiveCareOccupancy {
                    NumbersView(
                        numberRepresentation: .intensiveCareOccupancy,
                        latestNumber: intensiveCareOccupancy.newAdmissions ?? -1,
                        trendNumber: intensiveCareOccupancy.newAdmissionsTrend ?? 0
                    )
                }
                NumbersView(
                    numberRepresentation: .deaths,
                    latestNumber: entry.summary.deaths.new ?? -1,
                    trendNumber: entry.summary.deaths.trend ?? 0
                )
            }
            Spacer()
        }
        .padding(.horizontal)
    }

    struct NumbersView: View {

        private static let numberFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter
        }()

        private static let trendNumberFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.positivePrefix = "+"
            formatter.negativePrefix = "-"
            formatter.zeroSymbol = "0"
            return formatter
        }()

        let numberRepresentation: NumberRepresentation
        let latestNumber: Int
        let trendNumber: Int

        var image: Image {
            switch numberRepresentation {
            case .deaths:
                return Image(numberRepresentation.symbolName)
            default:
                return Image(systemName: numberRepresentation.symbolName)
            }
        }

        var body: some View {
            ZStack(alignment: .leading) {
                HStack {
                    image
                        .frame(width: 15, height: 15)
                        .font(.system(size: 18, weight: .light, design: .rounded))
                        .imageScale(.small)
                        .layoutPriority(50)
                    HStack(alignment: .lastTextBaseline, spacing: 2) {
                        Text(Self.numberFormatter.string(for: latestNumber) ?? "--")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                            .layoutPriority(100)
                        Text(Self.trendNumberFormatter.string(for: trendNumber) ?? "--")
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .foregroundColor(trendNumber.color)
                            .lineLimit(1)
                    }
                }
            }
        }

    }
}

@main
struct InfectedWidget: Widget {
    let kind: String = "InfectedWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            InfectedWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Latest Numbers")
        .description("Shows latest COVID-19 numbers in the Netherlands.")
        .supportedFamilies([.systemSmall])
    }
}

private extension Summary {

    static let dummyNumbers: Summary = {
        let now = Date()
        return Summary(
            updatedAt: now,
            numbersDate: now,
            regionCode: "NL00",
            municupalityName: nil,
            provinceName: nil,
            securityRegionName: nil,
            positiveCases: SummaryNumbers(
                new: 3764,
                trend: 320,
                total: 329402
            ),
            hospitalAdmissions: SummaryNumbers(
                new: 85,
                trend: 0,
                total: 42304
            ),
            hospitalOccupancy: Occupancy(
                newAdmissions: 287,
                newAdmissionsTrend: 23,
                currentlyOccupied: 1842,
                currentlyOccupiedTrend: -38
            ),
            intensiveCareOccupancy: Occupancy(
                newAdmissions: 48,
                newAdmissionsTrend: -2,
                currentlyOccupied: 492,
                currentlyOccupiedTrend: 8
            ),
            deaths: SummaryNumbers(
                new: 48,
                trend: -16,
                total: 8932
            )
        )
    }()

}

private extension Int {

    var color: Color {
        switch signum() {
        case -1:
            return .green
        case 0:
            return .orange
        case 1:
            return .red
        default:
            fatalError()
        }
    }

}

private extension NumberRepresentation {

    var symbolName: String {
        switch self {
        case .cases:
            return "plus.rectangle.on.folder"
        case .hospitalizations, .hospitalOccupancy:
            return "cross"
        case .intensiveCareOccupancy:
            return "waveform.path.ecg.rectangle"
        case .deaths:
            return "heart.broken"
        }
    }

}

#if DEBUG
struct InfectedWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            InfectedWidgetEntryView(entry: SimpleEntry(date: Date(), summary: .dummyNumbers))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            InfectedWidgetEntryView(entry: SimpleEntry(date: Date(), summary: .dummyNumbers))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .environment(\.colorScheme, .dark)
        }
    }
}
#endif
