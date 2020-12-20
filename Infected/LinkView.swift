//
//  LinkView.swift
//  Infected
//
//  Created by marko on 12/20/20.
//

import SwiftUI

struct LinkView: View {

    let titleKey: LocalizedStringKey
    let url: URL

    var body: some View {
        HStack {
            Link(titleKey, destination: url)
            Spacer()
            Image(systemName: "link")
        }
        .foregroundColor(.blue)
    }

}

#if DEBUG
struct LinkView_Previews: PreviewProvider {
    static var previews: some View {
        LinkView(titleKey: "Link", url: URL(string: "https://github.com/hungrxyz/Infected")!)
    }
}
#endif
