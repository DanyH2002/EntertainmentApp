//
//  Favorite.swift
//  EntertainmentApp
//
//  Created by Hulda Daniela Crisanto Luna on 24/11/25.
//

import Foundation

struct Favorite: Codable, Identifiable {
    let id: Int
    let item_id: Int
    let type: String
    let title: String
}
