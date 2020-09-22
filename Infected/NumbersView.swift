//
//  NumbersView.swift
//  Infected
//
//  Created by marko on 9/20/20.
//

import SwiftUI

struct NumbersView: View {

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()

    private static let relativeDateTimeFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        return formatter
    }()

    let numbers: DailyNumbers
    let refreshed: Date

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("➕  \(numbers.diagnosed)")
            Text("🏥  \(numbers.hospitalized)")
            Text("⚰️  \(numbers.deceased)")
            Text(Self.dateFormatter.string(from: numbers.date))
                .font(.footnote)
                .foregroundColor(.secondary)
            Text(refreshed, style: .relative)
                .font(.footnote)
                .foregroundColor(.secondary)
            + Text(" ago")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
    }
}

struct NumbersView_Previews: PreviewProvider {
    static var previews: some View {
        NumbersView(numbers: .demo, refreshed: Date().addingTimeInterval(-3600))
    }
}

private extension DailyNumbers {

    static var demo: DailyNumbers {
        DailyNumbers(
            date: Date(),
            diagnosed: 1,
            hospitalized: 2,
            deceased: 3,
            totalDiagnosed: 4,
            totalHospitalized: 5,
            totalDeceased: 6
        )
    }

}
