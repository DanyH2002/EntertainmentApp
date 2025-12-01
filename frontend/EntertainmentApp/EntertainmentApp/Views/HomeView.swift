//
//  HomeView.swift
//  EntertainmentApp
//
//  Created by Hulda Daniela Crisanto Luna on 25/11/25.
//

import SwiftUI

struct HomeView: View {
    @State private var movies: [Movie] = []
    @State private var loading = true
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationStack {
            Group {
                if loading {
                    ProgressView("Cargando películas...")
                }
                else if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
                else {
                    List(movies) { movie in
                        NavigationLink(destination: MovieDetailView(id:movie.id)) {
                            HStack {
                                MoviePoster(url: movie.poster)
                                    .frame(width: 60, height: 90)
                                
                                VStack(alignment: .leading) {
                                    Text(movie.title)
                                        .font(.headline)
                                    
                                    Text(movie.overview)
                                        .font(.caption)
                                        .lineLimit(3)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Películas")
            .onAppear {
                loadPopularMovies()
            }
        }
    }
    
    func loadPopularMovies() {
        guard let url = URL(string: "http://127.0.0.1:8000/api/tmdb/movies/popular") else {
            errorMessage = "URL inválida"
            return
        }
        
        ApiService().sendRequest(url: url, method: "GET", body: nil) { json, error in
            DispatchQueue.main.async {
                loading = false
                
                if let error = error {
                    errorMessage = error
                    return
                }
                
                guard let json = json else {
                    errorMessage = "Respuesta vacía"
                    return
                }
                
                if let results = json["results"] as? [[String: Any]] {
                    do {
                        let data = try JSONSerialization.data(withJSONObject: results)
                        let decodedMovies = try JSONDecoder().decode([Movie].self, from: data)
                        self.movies = decodedMovies
                    } catch {
                        errorMessage = "Error al decodificar datos"
                    }
                } else {
                    errorMessage = "Formato de datos inválido"
                }
            }
        }
    }
}

#Preview {
    HomeView()
}

