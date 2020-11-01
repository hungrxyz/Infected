//
//  ProvincesView.swift
//  Infected
//
//  Created by marko on 11/1/20.
//

import SwiftUI

struct ProvincesView: View {

    let numbers: [ProvinceNumbers]

    var body: some View {
        List {
            ForEach(numbers) { province in
                AreaView(area: province)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("Provinces", displayMode: .inline)
    }
}

struct ProvincesView_Previews: PreviewProvider {
    static var previews: some View {
        ProvincesView(numbers: [])
    }
}
