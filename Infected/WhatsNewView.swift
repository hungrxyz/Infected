//
//  WhatsNewView.swift
//  Infected
//
//  Created by marko on 8/8/21.
//

import SwiftUI

struct WhatsNewView: View {

    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        NavigationView {
            ScrollView {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Group {
                            Text("What's New")
                                .font(.title).bold()
                            Spacer()
                            Text("Version 1.8.0")
                                .font(.title2).bold()
                            Text("1.8.0 Update")
                        }
                    }
                    Spacer()
                }
                .padding()
            }
            .navigationBarItems(trailing: CloseButton { presentationMode.wrappedValue.dismiss() })
            .navigationBarTitleDisplayMode(.inline)
        }
    }

}

#if DEBUG
struct WhatsNewView_Previews: PreviewProvider {
    static var previews: some View {
        WhatsNewView()
    }
}
#endif
