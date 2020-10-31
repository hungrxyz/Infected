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

    private let numbersProvider = NumbersProvider()

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), numbers: .demo)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), numbers: .demo)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {

        numbersProvider.$national
            .filter { $0 != nil }
            .sink { completion in
                print(completion)
            } receiveValue: { numbers in
                let now = Date()
                let entry = SimpleEntry(date: now, numbers: numbers!)

                let after1Hour = Calendar.current.date(byAdding: .hour, value: 1, to: now)!

                let timeline = Timeline(entries: [entry], policy: .after(after1Hour))

                completion(timeline)
            }.store(in: &cancellables)

        numbersProvider.reload()

    }

}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let numbers: NationalNumbers
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
                Text("NL - \(Self.dateFormatter.string(from: entry.numbers.latest.date))")
                    .font(Font.system(size: 15, weight: .semibold))
                    .foregroundColor(.secondary)
                NumbersView(
                    kindText: "New Cases",
                    latestNumber: entry.numbers.latest.cases ?? 0,
                    trendNumber: entry.numbers.casesDifferenceToPreviousDay ?? 0
                )
                NumbersView(
                    kindText: "Hospitalizations",
                    latestNumber: entry.numbers.latest.hospitalizations ?? 0,
                    trendNumber: entry.numbers.hospitalizationsDifferenceToPreviousDay ?? 0
                )
                NumbersView(
                    kindText: "Deaths",
                    latestNumber: entry.numbers.latest.deaths ?? 0,
                    trendNumber: entry.numbers.deathsDifferenceToPreviousDay ?? 0
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

        let kindText: String
        let latestNumber: Int
        let trendNumber: Int

        var body: some View {
            VStack(alignment: .leading) {
                Text(kindText)
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
        .description("Displays latest infection numbers in the Netherlands.")
        .supportedFamilies([.systemSmall])
    }
}

struct InfectedWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            InfectedWidgetEntryView(entry: SimpleEntry(date: Date(), numbers: .random))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            InfectedWidgetEntryView(entry: SimpleEntry(date: Date(), numbers: .demo))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .environment(\.colorScheme, .dark)
        }
    }
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

