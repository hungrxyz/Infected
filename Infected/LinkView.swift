//
//  LinkView.swift
//  Infected
//
//  Created by marko on 12/20/20.
//

import SwiftUI

struct LinkView: View {

    let url: URL
    let titleKey: LocalizedStringKey
    let footnoteKey: LocalizedStringKey?

    init(url: URL,
         titleKey: LocalizedStringKey,
         footnoteKey: LocalizedStringKey? = nil) {
        self.url = url
        self.titleKey = titleKey
        self.footnoteKey = footnoteKey
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Link(titleKey, destination: url)
                if let footnoteKey = footnoteKey {
                    Text(footnoteKey)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
            Image(systemName: "arrow.up.forward")
        }
        .foregroundColor(.blue)
    }

}

#if DEBUG
struct LinkView_Previews: PreviewProvider {
    static var previews: some View {
        LinkView(url: URL(string: "https://github.com/hungrxyz/Infected")!,
                 titleKey: "Link",
                 footnoteKey: "Footnote")
    }
}
#endif
