//
//  InfectedApp.swift
//  Infected
//
//  Created by marko on 9/19/20.
//

import SwiftUI

@main
struct InfectedApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(NumbersProvider())
        }
    }
}
