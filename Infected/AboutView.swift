//
//  AboutView.swift
//  Infected
//
//  Created by marko on 11/13/20.
//

import SwiftUI

struct AboutView: View {

    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Data Sources")) {
                    LinkView(
                        titleKey: "RIVM",
                        url: URL( "https://data.rivm.nl/geonetwork/srv/dut/catalog.search#/metadata/5f6bc429-1596-490e-8618-1ed8fd768427")
                    )
                }
                Section(header: Text("Acknowledgements")) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Dennis Koolwijk")
                        Text("App icon; virus and broken heart symbols.")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
                Section {
                    LinkView(
                        titleKey: "Follow us on Twitter",
                        url: URL("https://twitter.com/Infected_App")
                    )
                    LinkView(
                        titleKey: "View on GitHub",
                        url: URL("https://github.com/hungrxyz/Infected")
                    )
                }
                if let appVersionText = Bundle.main.appVersionDisplayText {
                    Section {
                        HStack {
                            Text("App Version")
                            Spacer()
                            Text(appVersionText)
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("Infected")
            .navigationBarItems(trailing: CloseButton { presentationMode.wrappedValue.dismiss()
            })
            .navigationBarTitleDisplayMode(.inline)
        }

    }

}

private extension Bundle {

    var appVersionDisplayText: String? {
        guard
            let marketingVersion = infoDictionary?["CFBundleShortVersionString"] as? String,
            let buildNumber = infoDictionary?["CFBundleVersion"] as? String
        else {
            return nil
        }
        return "\(marketingVersion) (\(buildNumber))"
    }

}

private extension URL {

    init(_ string: StaticString) {
        self.init(string: String("\(string)"))!
    }

}

#if DEBUG
struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
#endif
