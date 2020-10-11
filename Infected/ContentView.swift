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
            if let numbers = api.latest.first {
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
        .onAppear {
            api.load()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(api: CoronaWatchNLAPI(latest: [DailyNumbers.demo]))
            ContentView()
        }
        .previewDevice("iPhone 11 Pro")
    }
}
