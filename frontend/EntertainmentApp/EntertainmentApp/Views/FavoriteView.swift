//
//  FavoriteView.swift
//  EntertainmentApp
//
//  Created by Hulda Daniela Crisanto Luna on 24/11/25.
//

import SwiftUI


struct FavoriteView: View {
    @State private var userName: String = ""
    @State private var userEmail: String = ""
    @State private var movies: [Favorite] = []
    @State private var series: [Favorite] = []
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    @EnvironmentObject var api: ApiService
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                if !userName.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Usuario: \(userName)")
                            .font(.headline)
                        Text(userEmail)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                }
                
                List {
                    if !movies.isEmpty {
                        Section("Películas") {
                            ForEach(movies) { fav in
                                favoriteRow(fav: fav, isMovie: true)
                            }
                        }
                    }
                    
                    if !series.isEmpty {
                        Section("Series") {
                            ForEach(series) { fav in
                                favoriteRow(fav: fav, isMovie: false)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Mis Favoritos")
            .onAppear {
                loadFavorites()
            }
        }
    }
    
    // Lista de favoritos
    @ViewBuilder
    func favoriteRow(fav: Favorite, isMovie: Bool) -> some View {
        HStack {
            NavigationLink {
                if isMovie {
                    MovieDetailView(id: fav.itemId)
                } else {
                    SeriesDetailView(id: fav.itemId)
                }
            } label: {
                VStack(alignment: .leading) {
                    Text(fav.title)
                        .font(.body)
                        .foregroundColor(.primary)

                    Text("ID: \(fav.itemId)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            Button {
                deleteFavorite(id: fav.id)
            } label: {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
            .buttonStyle(.borderless)
        }
    }

    
    // Servicios
    func loadFavorites() {
        isLoading = true
        Task {
            do {
                let response = try await api.getFavorites()
                
                DispatchQueue.main.async {
                    self.userName = response.user.name
                    self.userEmail = response.user.email
                    self.movies = response.favorites.movies
                    self.series = response.favorites.series
                }
            } catch {
                errorMessage = "No se pudo cargar favoritos"
                print("Error:", error)
            }
            
            isLoading = false
        }
    }
    
    func deleteFavorite(id: Int) {
        Task {
            do {
                let _ = try await api.deleteFavorite(id: id)
                loadFavorites()
                
            } catch {
                errorMessage = "Error al eliminar favorito"
            }
        }
    }
}

#Preview {
    FavoriteView()
        .environmentObject(ApiService())
}
