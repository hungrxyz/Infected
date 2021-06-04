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
                        url: URL( "https://data.rivm.nl/geonetwork/srv/dut/catalog.search#/metadata/5f6bc429-1596-490e-8618-1ed8fd768427"),
                        titleKey: "RIVM",
                        footnoteKey: "Confirmed cases and deaths."
                    )
                    LinkView(
                        url: URL( "https://data.rivm.nl/geonetwork/srv/dut/catalog.search#/metadata/4f4ad069-8f24-4fe8-b2a7-533ef27a899f"),
                        titleKey: "RIVM + NICE",
                        footnoteKey: "Hospitalizations."
                    )
                    LinkView(
                        url: URL( "https://www.databronnencovid19.nl/Bron?naam=Nationale-Intensive-Care-Evaluatie"),
                        titleKey: "NICE",
                        footnoteKey: "New Intensive Care admissions."
                    )
                    LinkView(
                        url: URL("https://lcps.nu/datafeed/"),
                        titleKey: "LCPS",
                        footnoteKey: "Hospital occupancy."
                    )
                    LinkView(
                        url: URL("https://coronadashboard.government.nl/landelijk/vaccinaties"),
                        titleKey: "Coronavirus Dashboard",
                        footnoteKey: "Vaccinations."
                    )
                    LinkView(
                        url: URL("https://luscii.com"),
                        titleKey: "Luscii",
                        footnoteKey: "Home admissions."
                    )
                }
                Section(header: Text("Acknowledgements")) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Dennis Koolwijk")
                        Text("App icon; virus and broken heart symbols.")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                    LinkView(
                        url: URL("https://github.com/Geri-Borbas/iOS.Blog.SwiftUI_Search_Bar_in_Navigation_Bar"),
                        titleKey: "SwiftUI Search Bar in Navigation Bar"
                    )
                }
                Section {
                    LinkView(
                        url: URL("https://apps.apple.com/app/id1537441887?action=write-review"),
                        titleKey: "Leave a Review on App Store"
                    )
                    LinkView(
                        url: URL("https://twitter.com/Infected_App"),
                        titleKey: "Follow us on Twitter"
                    )
                    LinkView(
                        url: URL("https://github.com/hungrxyz/Infected"),
                        titleKey: "View on GitHub"
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
            let buildNumber = infoDictionary?[kCFBundleVersionKey as String] as? String
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
