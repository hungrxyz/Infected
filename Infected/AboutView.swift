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
                    LinkRow(titleKey: "RIVM COVID-19 Dataset",
                            url: URL(string: "https://data.rivm.nl/covid-19/")!)
                    LinkRow(titleKey: "CoronaWatchNL",
                            url: URL(string: "https://github.com/J535D165/CoronaWatchNL")!)
                }
                Section(header: Text("Acknowledgements")) {
                    LinkRow(titleKey: "CodableCSV",
                            url: URL(string: "https://github.com/dehesa/CodableCSV")!)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Dennis Koolwijk")
                        Text("App icon; virus and broken heart symbols.")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
                Section {
                    LinkRow(titleKey: "View on GitHub",
                            url: URL(string: "https://github.com/hungrxyz/Infected")!)
                    LinkRow(titleKey: "Created by @hungrxyz",
                            url: URL(string: "https://twitter.com/hungrxyz")!)
                    if let appVersionText = Bundle.main.appVersionDisplayText {
                        Text(appVersionText)
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
                Image(systemName: "arrow.turn.up.right")
            }
            .foregroundColor(.primary)
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

#if DEBUG
struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
#endif
