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
            if !Thread.isMainThread {
                print("isLoggedIn modificado desde background thread")
            }
        }
    }
}
