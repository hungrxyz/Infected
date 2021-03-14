//
//  VaccinationsInfoView.swift
//  Infected
//
//  Created by marko on 3/14/21.
//

import SwiftUI

struct VaccinationsInfoView: View {

    private var newView: some View {
        Group {
            Text("New")
                .font(.title2).bold()
            Text("New vaccinations is calculated by subtracting previous day total with current day total of vaccinations administered.")
            Text("Average")
                .font(.title3).bold()
            Text("7 day average is calculated by summing up new vaccinations for past 7 days and dividing the sum by 7.")
            Text("Trend is calculated by subtracting current 7 day average from from previous 7 day average.")
        }
    }

    private var coverageView: some View {
        Group {
            Text("Coverage")
                .font(.title2).bold()
            Text("Calculated by multiplying number of administered doses with the dosage of administered doses then dividing the result with the national population.\n[(administered doses * dosage) / national population]")
            Text("Dosage")
                .font(.title3).bold()
            Text("Represents quantity of doses required to be fully vaccinated. E.g. 2 doses / person = 0.5, 1 dose / person = 1.0.")
        }
    }

    private var herdImmunityView: some View {
        Group {
            Text("Herd Immunity")
                .font(.title2).bold()
            Text("Herd immunity is reached when 70% of people are fully vaccinated. Two different estimated dates are provided, one based on expected deliveries of doses and another based on current 7 day average of doses administered.")
            Text("Expected Deliveries")
                .font(.title3).bold()
            Text("Calculated by adding average number of expected deliveries per day (different per quarter and year) to current number of total doses administered until threshold of 70% of national population is reached. Each time the total value is incremented, a day is added to current date which results in expected date.")
            Text("Current Trend")
                .font(.title3).bold()
            Text("Calculated by adding current 7 day average of doses administered per day to current number of total doses administered until threshold of 70% of national population is reached. Each time the total value is incremented, a day is added to current date which results in expected date.")
        }
    }

    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        NavigationView {
            ScrollView {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Group {
                            Text("Vaccinations")
                                .font(.title).bold()
                            Spacer()
                        }
                        newView
                        Spacer()
                        coverageView
                        Spacer()
                        herdImmunityView
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

struct VaccinationsInfoView_Previews: PreviewProvider {
    static var previews: some View {
        VaccinationsInfoView()
    }
}

