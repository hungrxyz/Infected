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
                    LinkRow(
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
                    LinkRow(
                        titleKey: "Follow us on Twitter",
                        url: URL("https://twitter.com/Infected_App")
                    )
                    LinkRow(
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
            .navigationBarItems(trailing: CloseButton { presentationMode.wrappedValue.dismiss() })
            .navigationBarTitleDisplayMode(.inline)
        }

    }

    private struct LinkRow: View {

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
