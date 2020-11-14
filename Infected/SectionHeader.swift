//
//  SectionHeader.swift
//  Infected
//
//  Created by marko on 11/13/20.
//

import SwiftUI

struct SectionHeader: View {
    let text: String

    var body: some View {
        Text(text.capitalized)
            .font(.title2).bold()
            .foregroundColor(.primary)
    }
}

struct SectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            List {
                Section(header: SectionHeader(text: UUID().uuidString)) {
                    Text(UUID().uuidString)
                }
            }
            List {
                Section(header: SectionHeader(text: UUID().uuidString)) {
                    Text(UUID().uuidString)
                }
            }
            .listStyle(GroupedListStyle())
            List {
                Section(header: SectionHeader(text: UUID().uuidString)) {
                    Text(UUID().uuidString)
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
    }
}
