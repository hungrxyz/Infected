//
//  AllRegionsView.swift
//  Infected
//
//  Created by marko on 11/1/20.
//

import SwiftUI

struct AllRegionsView: View {

    let nationalNumbers: Summary?
    let provincialNumbers: [ProvinceNumbers]
    let municipalNumbers: [MunicipalityNumbers]

    var body: some View {
        List {
            if let nationalNumbers = nationalNumbers {
                NavigationLink(destination: NetherlandsView(numbers: nationalNumbers)) {
                    Text("Netherlands")
                }
            }
            NavigationLink(destination: ProvincesView(numbers: provincialNumbers)) {
                Text("Provinces")
            }
            NavigationLink(destination: MunicipalitiesView(numbers: municipalNumbers)) {
                Text("Municipalities")
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("Regions")
    }
}

#if DEBUG
struct AreasView_Previews: PreviewProvider {
    static var previews: some View {
        AllRegionsView(nationalNumbers: .demo, provincialNumbers: [], municipalNumbers: [])
    }
}
#endif
