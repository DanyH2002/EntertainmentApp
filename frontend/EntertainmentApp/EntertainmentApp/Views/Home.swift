//
//  Home.swift
//  EntertainmentApp
//
//  Created by Hulda Daniela Crisanto Luna on 24/11/25.
//

import SwiftUI

struct Home: View {
    var body: some View {
        TabView{
            Tab("Peliculas",systemImage: "film"){
                HomeView()
            }
            Tab("Series", systemImage: "tv"){
                SeriesView()
            }
            Tab("Favoritos", systemImage: "heart"){
                FavoriteView()
            }
        }
        .padding()
    }
}

#Preview {
    Home()
}
