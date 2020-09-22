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
        VStack(spacing: 16) {
            if let numbers = api.latest {
                NumbersView(numbers: numbers, refreshed: Date())
            } else {
                Text("No latest numbers")
            }
            Button(action: {
                api.load()
            }, label: {
                Text("Refresh")
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
