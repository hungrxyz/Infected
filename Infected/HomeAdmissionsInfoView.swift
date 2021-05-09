//
//  HomeAdmissionsInfoView.swift
//  Infected
//
//  Created by marko on 5/9/21.
//

import SwiftUI

struct HomeAdmissionsInfoView: View {

    private var descriptionView: some View {
        Group {
            Text("Home Admissions")
                .font(.title).bold()
            Spacer()
            Text("Home Admissions About Description")
        }
    }

    private var newView: some View {
        Group {
            Text("New Admissions")
                .font(.title2).bold()
            Text("New home admissions is calculated by subtracting previous day total activated from current day total activated admissions.")
        }
    }

    private var activeView: some View {
        Group {
            Text("Active")
                .font(.title2).bold()
            Text("Active number is calculated by subtracting total stopped from total activated admissions.")
        }
    }

    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        NavigationView {
            ScrollView {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        descriptionView
                        Spacer()
                        newView
                        Spacer()
                        activeView
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

struct HomeAdmissionsInfoView_Previews: PreviewProvider {
    static var previews: some View {
        HomeAdmissionsInfoView()
    }
}
