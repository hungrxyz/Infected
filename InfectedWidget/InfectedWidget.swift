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
            VStack(alignment: .leading, spacing: 4) {
                Text("NL - \(Self.dateFormatter.string(from: entry.summary.updatedAt ?? Date()))")
                    .font(Font.system(size: 14, weight: .semibold))
                    .foregroundColor(.secondary)
                NumbersView(
                    kindLocalizedStringKey: "New Cases",
                    latestNumber: entry.summary.positiveCases.new ?? 0,
                    trendNumber: entry.summary.positiveCases.trend ?? 0
                )
                NumbersView(
                    kindLocalizedStringKey: "Hospitalizations",
                    latestNumber: entry.summary.hospitalAdmissions.new ?? 0,
                    trendNumber: entry.summary.hospitalAdmissions.trend ?? 0
                )
                NumbersView(
                    kindLocalizedStringKey: "Deaths",
                    latestNumber: entry.summary.deaths.new ?? 0,
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

        let kindLocalizedStringKey: LocalizedStringKey
        let latestNumber: Int
        let trendNumber: Int

        var body: some View {
            VStack(alignment: .leading) {
                Text(kindLocalizedStringKey)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.secondary)
                HStack(alignment: .lastTextBaseline, spacing: 4) {
                    Text(Self.numberFormatter.string(for: latestNumber) ?? "--")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    Text(Self.trendNumberFormatter.string(for: trendNumber) ?? "--")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(trendNumber.color)
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
            deaths: SummaryNumbers(
                new: 48,
                trend: -16,
                total: 8932
            )
        )
    }()

}

private extension NationalNumbers {

    static let dummyNumbers: NationalNumbers = {
        let now = Date()
        return NationalNumbers(
            latest: Numbers(date: now, cases: 12939, hospitalizations: 238, deaths: 42),
            previous: Numbers(date: now, cases: 9020, hospitalizations: 238, deaths: 67),
            total: Numbers(date: now, cases: 432032, hospitalizations: 10429, deaths: 4389)
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
