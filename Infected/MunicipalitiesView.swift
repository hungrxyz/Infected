//
//  MunicipalitiesView.swift
//  Infected
//
//  Created by marko on 11/1/20.
//

import SwiftUI

struct MunicipalitiesView: View {

    let numbers: [MunicipalityNumbers]

    var body: some View {
        List {
            ForEach(numbers) { municipality in
                RegionView(region: municipality)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("Municipalities", displayMode: .inline)
    }
}

struct MunicipalitiesView_Previews: PreviewProvider {
    static var previews: some View {
        MunicipalitiesView(numbers: [])
    }
}
