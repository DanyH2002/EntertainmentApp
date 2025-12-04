//
//  AppState.swift
//  EntertainmentApp
//
//  Created by Hulda Daniela Crisanto Luna on 24/11/25.
//

import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false {
        didSet {
            print("🔄 isLoggedIn cambiado a: \(isLoggedIn), Thread main: \(Thread.isMainThread)")
            if !Thread.isMainThread {
                print("⚠️ PELIGRO: isLoggedIn modificado desde background thread!")
            }
        }
    }
}
