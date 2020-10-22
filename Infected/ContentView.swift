//
//  ContentView.swift
//  Infected
//
//  Created by marko on 9/19/20.
//

import SwiftUI

struct ContentView: View {

    @ObservedObject var api = CoronaWatchNLAPI()

    @ViewBuilder
    var body: some View {
        NavigationView {
            if let numbers = api.latestNumbers {
                List {
                    DaySectionView(numbers: numbers)
                    TotalSectionView(numbers: numbers)
                }
                .listStyle(InsetGroupedListStyle())
                .navigationBarTitle("Latest")
            } else {
                Text("No latest numbers")
                    .navigationBarTitle("Latest")
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(api: CoronaWatchNLAPI(latestNumbers: .demo))
            ContentView()
        }
        .previewDevice("iPhone 11 Pro")
    }
}
