//
//  GroupedRegionsView.swift
//  Infected
//
//  Created by marko on 11/1/20.
//

import SwiftUI

struct GroupedRegionsView: View {

    let geoArea: GeoArea
    let summaries: [Summary]

    var body: some View {
        List {
            ForEach(summaries) { summary in
                RegionView(summary: summary)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle(geoArea.localizedName, displayMode: .inline)
    }

}

#if DEBUG
struct ProvincesView_Previews: PreviewProvider {
    static var previews: some View {
        GroupedRegionsView(geoArea: .national, summaries: [.demo, .random])
    }
}
#endif
