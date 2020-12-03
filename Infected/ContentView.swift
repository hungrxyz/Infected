//
//  ContentView.swift
//  Infected
//
//  Created by marko on 9/19/20.
//

import SwiftUI

struct ContentView: View {

    @StateObject var numbersProvider = NumbersProvider()
    @State var isAboutShown = false

    private var aboutButton: some View {
        Button(action: {
            isAboutShown.toggle()
        }, label: {
            Image("virus")
                .imageScale(.large)
        })
    }

    private let willEnterForegroundPublisher = NotificationCenter.default
        .publisher(for: UIApplication.willEnterForegroundNotification)
        .map { _ in }

    var body: some View {
        NavigationView {
            DailyView(numbersProvider: numbersProvider)
                .navigationBarItems(trailing: aboutButton)
                .sheet(isPresented: $isAboutShown, content: {
                    AboutView()
                })
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: numbersProvider.reloadAllRegions)
        .onReceive(willEnterForegroundPublisher, perform: numbersProvider.reloadAllRegions)
    }

    private struct DailyView: View {

        private static let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            formatter.doesRelativeDateFormatting = true
            return formatter
        }()

        @ObservedObject var numbersProvider: NumbersProvider

        var body: some View {
            if let national = numbersProvider.national {
                List {
                    RegionView(summary: national)
                    NavigationLink(
                        destination: AllRegionsView(
                            national: national,
                            provinces: numbersProvider.provincialSummaries,
                            securityRegions: numbersProvider.securityRegionsSummaries,
                            municipalities: numbersProvider.municipalSummaries
                        )
                    ) {
                        Text("All Regions")
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .navigationBarTitle(Self.dateFormatter.string(from: national.numbersDate!))
            } else {
                Text("No latest numbers")
            }
        }
    }

}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(numbersProvider: .demo)
            ContentView()
        }
        .previewDevice("iPhone 12 mini")
    }
}

private extension NumbersProvider {

    static var demo: NumbersProvider {
        let provider = NumbersProvider()
        provider.national = .demo
        return provider
    }

}
#endif
