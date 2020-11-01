//
//  NetherlandsView.swift
//  Infected
//
//  Created by marko on 11/1/20.
//

import SwiftUI

struct NetherlandsView: View {

    let numbers: NationalNumbers

    var body: some View {
        List {
            AreaView(area: numbers)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("Netherlands", displayMode: .inline)
    }
}

struct NetherlandsView_Previews: PreviewProvider {
    static var previews: some View {
        NetherlandsView(numbers: .demo)
    }
}
