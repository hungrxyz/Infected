//
//  InfectedWidget.swift
//  InfectedWidget
//
//  Created by marko on 9/20/20.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    private let api = CoronaWatchNLAPI()

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), numbers: .demo)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), numbers: .demo)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {

        api.load { numbers in

            let now = Date()
            let entry = SimpleEntry(date: now, numbers: numbers[0])

            let after1Hour = Calendar.current.date(byAdding: .hour, value: 1, to: now)!

            let timeline = Timeline(entries: [entry], policy: .after(after1Hour))

            completion(timeline)

        }

    }

}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let numbers: DailyNumbers
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
                Text(Self.dateFormatter.string(from: entry.numbers.date))
                    .font(Font.system(size: 17, weight: .semibold))
                    .foregroundColor(.secondary)
                RowView(imageName: "plus", captionText: "New cases", value: entry.numbers.diagnosed)
                RowView(imageName: "bed.double", captionText: "Hospitalized", value: entry.numbers.hospitalized)
                RowView(imageName: "xmark", captionText: "Deceased", value: entry.numbers.deceased)
            }
            Spacer()
        }
        .padding()
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
        InfectedWidgetEntryView(entry: SimpleEntry(date: Date(), numbers: .demo))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
