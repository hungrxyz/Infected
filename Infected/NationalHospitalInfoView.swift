//
//  NationalHospitalInfoView.swift
//  Infected
//
//  Created by marko on 12/19/20.
//

import SwiftUI

struct NationalHospitalInfoView: View {

    private var subheadlineText: Text {
        Text("Numbers of ") + Text("New").italic() + Text(" and ") + Text("Occupied Beds").italic() + Text(" are coming from different sources and are not directly corelated.")
    }

    private var newAdmissionsView: some View {
        Group {
            Text("New Admissions")
                .font(.title2).bold()
            Text("New hospital and intensive care admissions are calculated by summing up new admissions for yesterday, two and three days ago, then diving the sum by three.")
            Text("Trend for new admissions is calculated by subtracting the average of yesterday, two and three days ago from the average of four, five and six days ago.")
        }
    }

    private var per100kView: some View {
        Group {
            Text("Per 100 000 (100k) People")
                .font(.title2).bold()
            Text("Per 100 000 people ratio is calculated by first dividing the number of new admissions with the population of the region, then multiplying the result by 100 000 [(new admissions / population) * 100 000].")
        }
    }

    private var occupiedBedsView: some View {
        Group {
            Text("Occupied Beds")
                .font(.title2).bold()
            Text("Currently Occupied Beds is displayed as provided by the LCPS. Values are for today.")
            Text("Trend is caluclated by subtracting todays value with the value from yesterday.")
        }
    }

    private var differentSourcesView: some View {
        Group {
            Text("Why are numbers of New and Occupied Beds coming from different sources")
                .font(.headline)
            HStack {
                Rectangle()
                    .frame(width: 4)
                Text("LCPS - NICE difference FAQ quote")
                    .italic()
            }
            .foregroundColor(.secondary)
            Link("Source - LCPS FAQ", destination: URL(string: "https://lcps.nu/veelgestelde-vragen/")!)
                .foregroundColor(.blue)
        }
    }

    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        NavigationView {
            ScrollView {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Group {
                            Text("Hospital / Intensive Care Occupancy")
                                .font(.title).bold()
                            Spacer()
                        }
                        subheadlineText
                        Spacer()
                        newAdmissionsView
                        Spacer()
                        per100kView
                        Spacer()
                        occupiedBedsView
                        Spacer()
                        differentSourcesView
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

struct NationalHospitalInfoView_Previews: PreviewProvider {
    static var previews: some View {
        NationalHospitalInfoView()
    }
}
