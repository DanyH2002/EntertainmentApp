//
//  Favorite.swift
//  EntertainmentApp
//
//  Created by Hulda Daniela Crisanto Luna on 24/11/25.
//

import Foundation

struct Favorite: Codable, Identifiable {
    let id: Int
    let userId: Int
    let itemId: Int
    let type: String
    let title: String
}

struct FavoritesResponse: Codable {
    let success: Bool
    let user: FavoriteUser
    let favorites: FavoritesGroup
}

struct FavoritesGroup: Codable {
    let movies: [Favorite]
    let series: [Favorite]
}

struct FavoriteUser: Codable {
    let id: Int
    let name: String
    let email: String
}

struct AddFavoriteResponse: Codable {
    let success: Bool
    let message: String
    let favorite: Favorite
}

struct DeleteFavoriteResponse: Codable {
    let success: Bool
    let message: String
}
