//
//  ContentView.swift
//  Infected
//
//  Created by marko on 9/19/20.
//

import SwiftUI

struct ContentView: View {

    @ObservedObject var numbersProvider = NumbersProvider()

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()

    @ViewBuilder
    var body: some View {
        NavigationView {
            if let national = numbersProvider.national {
                List {
                    AreaView(area: national)
                    NavigationLink(
                        destination: AreasView(
                            nationalNumbers: national,
                            provincialNumbers: numbersProvider.provincial,
                            municipalNumbers: numbersProvider.municipal
                        )
                    ) {
                        Text("All Areas")
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .navigationBarTitle(Self.dateFormatter.string(from: national.latest.date))
            } else {
                Text("No latest numbers")
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: numbersProvider.reloadAllAreas)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification),
                   perform: { _ in  numbersProvider.reloadAllAreas() })
    }

}

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
