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
                }
                Section(header: Text("Acknowledgements")) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Dennis Koolwijk")
                        Text("App icon; virus and broken heart symbols.")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
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
