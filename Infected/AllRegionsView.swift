//
//  AllRegionsView.swift
//  Infected
//
//  Created by marko on 11/1/20.
//

import SwiftUI

struct AllRegionsView: View {

    let national: Summary?
    let provinces: [Summary]
    let securityRegions: [Summary]
    let municipalities: [Summary]

    var body: some View {
        List {
            if let national = national {
                let geoArea = GeoArea.national
                NavigationLink(destination: GroupedRegionsView(geoArea: geoArea, summaries: [national])) {
                    Text(geoArea.localizedName)
                }
            }
            if provinces.isEmpty == false {
                let geoArea = GeoArea.provincial
                NavigationLink(destination: GroupedRegionsView(geoArea: geoArea, summaries: provinces)) {
                    Text(geoArea.localizedName)
                }
            }
            if securityRegions.isEmpty == false {
                let geoArea = GeoArea.securityRegional
                NavigationLink(destination: GroupedRegionsView(geoArea: geoArea, summaries: securityRegions)) {
                    Text(geoArea.localizedName)
                }
            }
            if municipalities.isEmpty == false {
                let geoArea = GeoArea.municipal
                NavigationLink(destination: GroupedRegionsView(geoArea: geoArea, summaries: municipalities)) {
                    Text(geoArea.localizedName)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("Regions")
    }
}

#if DEBUG
struct AreasView_Previews: PreviewProvider {
    static var previews: some View {
        AllRegionsView(
            national: .random,
            provinces: [.random],
            securityRegions: [.random],
            municipalities: [.random]
        )
    }
}
#endif
