//
//  EntertainmentAppApp.swift
//  EntertainmentApp
//
//  Created by Hulda Daniela Crisanto Luna on 20/11/25.
//

import SwiftUI

@main
struct EntertainmentAppApp: App {
    @StateObject var appState = AppState()
    @StateObject var api = ApiService()
    var body: some Scene {
        WindowGroup {
            // ContentView()
            NavigationStack {
                if appState.isLoggedIn {
                    Home()
                } else {
                    LoginView()
                }
            }
            .environmentObject(appState)
            .environmentObject(api)
        }
    }
}
