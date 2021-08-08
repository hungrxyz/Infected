//
//  VaccinationsUpdatedCaptionView.swift
//  Infected
//
//  Created by marko on 7/19/21.
//

import SwiftUI

struct VaccinationsUpdatedCaptionView: View {

    private static let relativeDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()

    private static let weekdayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }()

    private func dateDisplayString() -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) || calendar.isDateInYesterday(date) {
            return Self.relativeDateFormatter.string(from: date)
        } else {
            return Self.weekdayDateFormatter.string(from: date)
        }
    }

    let date: Date

    var body: some View {
        Text(dateDisplayString())
            .font(.system(.caption, design: .rounded))
            .foregroundColor(.secondary)
    }
}

struct VaccinationsUpdatedCaptionView_Previews: PreviewProvider {
    static var previews: some View {
        VaccinationsUpdatedCaptionView(date: Date())
    }
}
