//
//  GroupedRegionsView.swift
//  Infected
//
//  Created by marko on 11/1/20.
//

import SwiftUI

struct GroupedRegionsView: View {

    @ObservedObject private var searchBar: SearchBar = SearchBar()

    private static let predicate = NSPredicate(format: "SELF CONTAINS[cd] $query")

    private var filteredSummaries: [Summary] {
        if searchBar.text.isEmpty {
            return summaries
        } else {
            return summaries
                .filter {
                    let provinceName = $0.provinceName?.replacingOccurrences(of: " ", with: "")
                    let regionName = $0.regionName.replacingOccurrences(of: " ", with: "")
                    let query = searchBar.text.replacingOccurrences(of: " ", with: "")
                    let variables = ["query": query]

                    return Self.predicate.evaluate(with: provinceName, substitutionVariables: variables)
                        || Self.predicate.evaluate(with: regionName, substitutionVariables: variables)
                }
        }
    }

    let geoArea: GeoArea
    let summaries: [Summary]

    var body: some View {
        List {
            ForEach(filteredSummaries) { summary in
                RegionView(summary: summary)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle(geoArea.localizedName, displayMode: .inline)
        .add(searchBar)
    }

}

#if DEBUG
struct ProvincesView_Previews: PreviewProvider {
    static var previews: some View {
        GroupedRegionsView(geoArea: .national, summaries: [.demo, .random])
    }
}
#endif
