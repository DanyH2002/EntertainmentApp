//
//  User.swift
//  EntertainmentApp
//
//  Created by Hulda Daniela Crisanto Luna on 24/11/25.
//

import Foundation

struct User: Codable, Identifiable {
    let id: Int
    let name: String?
    let last_name: String?
    let email: String
    let password: String?
}
