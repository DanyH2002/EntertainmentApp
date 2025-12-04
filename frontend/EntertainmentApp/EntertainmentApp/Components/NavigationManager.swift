//
//  NavigationManager.swift
//  EntertainmentApp
//
//  Created by Hulda Daniela Crisanto Luna on 03/12/25.
//
import SwiftUI
import Combine

class NavigationManager: ObservableObject {
    static let shared = NavigationManager()
    
    @Published var movieDetailID: Int? = nil
    @Published var seriesDetailID: Int? = nil
    
    private init() {}
    
    func pushMovieDetail(id: Int) {
        movieDetailID = id
    }
    
    func pushSeriesDetail(id: Int) {
        seriesDetailID = id
    }
}
