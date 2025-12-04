//
//  Search.swift
//  EntertainmentApp
//
//  Created by Hulda Daniela Crisanto Luna on 03/12/25.
//

import Foundation

struct SearchSeriesResponse: Codable {
    let page: Int
    let results: [Serie]
}

struct SearchMovieResponse: Codable {
    let page: Int
    let results: [Movie]
}

