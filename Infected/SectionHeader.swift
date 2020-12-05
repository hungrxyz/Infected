//
//  SectionHeader.swift
//  Infected
//
//  Created by marko on 11/13/20.
//

import SwiftUI

struct SectionHeader: View {
    let summary: Summary

    var body: some View {
        VStack(alignment: .leading) {
            if let provinceName = summary.provinceName, summary.isMunicipalityOrSecurityRegion {
                Text(provinceName)
                    .font(.callout)
                    .foregroundColor(.secondary)
            }
            Text(summary.regionName)
                .font(.title2).bold()
                .foregroundColor(.primary)
        }
    }

}

private extension Summary {

    var isMunicipalityOrSecurityRegion: Bool {
        regionCode.hasPrefix("GM") || regionCode.hasPrefix("VR")
    }

}

#if DEBUG
struct SectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            List {
                Section(header: SectionHeader(summary: .demo)) {
                    Text(UUID().uuidString)
                }
                .textCase(.none)
            }
            .listStyle(InsetGroupedListStyle())
            List {
                Section(header: SectionHeader(summary: .random)) {
                    Text(UUID().uuidString)
                }
            }
            .listStyle(GroupedListStyle())
            List {
                Section(header: SectionHeader(summary: .demo)) {
                    Text(UUID().uuidString)
                }
            }
        }
    }
}
#endif
