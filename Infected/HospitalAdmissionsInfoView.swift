//
//  HospitalAdmissionsInfoView.swift
//  Infected
//
//  Created by marko on 1/2/21.
//

import SwiftUI

struct HospitalAdmissionsInfoView: View {

    private var newAdmissionsView: some View {
        Group {
            Text("New Admissions")
                .font(.title2).bold()
            Text("New hospital admissions are calculated by summing up new admissions for yesterday, two and three days ago, then diving the sum by three.")
            Text("Trend for new admissions is calculated by subtracting the average of yesterday, two and three days ago from the average of four, five and six days ago.")
        }
    }

    private static let totalsDateDisplayString: String = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-MM-dd"

        let date = dateFormatter.date(from: "2020-02-27")!

        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none

        return dateFormatter.string(from: date)
    }()

    private var totalView: some View {
        Group {
            Text("Total")
                .font(.title2).bold()
            Text("Total number of hospital admissions is calculated by summing up all of the admissions since ") + Text(Self.totalsDateDisplayString) + Text(" to this day.")
        }
    }

    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        NavigationView {
            ScrollView {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Hospitalizations")
                            .font(.title).bold()
                        Spacer()
                        newAdmissionsView
                        Spacer()
                        totalView
                    }
                    Spacer()
                }
                .padding()
            }
            .navigationBarItems(trailing: CloseButton { presentationMode.wrappedValue.dismiss() })
            .navigationBarTitleDisplayMode(.inline)
        }
    }

}

struct HospitalAdmissionsInfoView_Previews: PreviewProvider {
    static var previews: some View {
        HospitalAdmissionsInfoView()
    }
}
