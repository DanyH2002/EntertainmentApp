//
//  MovieDetailView.swift
//  EntertainmentApp
//
//  Created by Hulda Daniela Crisanto Luna on 27/11/25.
//

import SwiftUI

struct MovieDetailView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var api: ApiService
    @State private var showAlert = false
    @State private var alertMessage = ""

    let id: Int

    @State private var movie: MovieDetail?
    @State private var isLoading = true
    @State private var showError = false
    @State private var animate = false

    var body: some View {
        ZStack {
            if let backdrop = movie?.backdropPath,
               let url = URL(string: "https://image.tmdb.org/t/p/original\(backdrop)") {
                
                AsyncImage(url: url) { img in
                    img.resizable()
                        .scaledToFill()
                        .blur(radius: 40)
                        .opacity(0.35)
                        .ignoresSafeArea()
                } placeholder: {
                    Color.black.opacity(0.4).ignoresSafeArea()
                }
                
            } else {
                Color.black.opacity(0.4).ignoresSafeArea()
            }
            
            ScrollView {
                VStack(spacing: 16) {
                    
                    Text(movie?.title ?? "Cargando...")
                        .font(.largeTitle.bold())
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding(.top, 8)
                    
                    if let rating = movie?.voteAverage {
                        Text("⭐️ \(String(format: "%.1f", rating))/10")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Sinopsis")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                        
                        Text(movie?.overview ?? "No hay descripción disponible.")
                            .foregroundColor(.white.opacity(0.95))
                            .font(.body)
                            .lineSpacing(6)
                            .multilineTextAlignment(.leading)
                            .padding(.top, 4)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    if let genres = movie?.genres, !genres.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Géneros")
                                .font(.title3.bold())
                                .foregroundColor(.white)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(genres, id: \.id) { genre in
                                        Text(genre.name)
                                            .font(.caption)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(Color.white.opacity(0.15))
                                            .clipShape(Capsule())
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    }
                    
                    if movie != nil {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Información")
                                .font(.title3.bold())
                                .foregroundColor(.white)
                            
                            VStack(spacing: 8) {
                                infoRow("Fecha de estreno", movie?.releaseDate)
                                infoRow("Duración", movie?.runtime != nil ? "\(movie?.runtime!) min" : nil)
                                infoRow("Estado", movie?.status)
                                infoRow("Idioma original", movie?.originalLanguage?.uppercased())
                                
                                if let homepage = movie?.homepage {
                                    infoRow("Página oficial", homepage.isEmpty ? "-" : homepage)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    }
                    
                    if let langs = movie?.spokenLanguages, !langs.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Idiomas hablados")
                                .font(.title3.bold())
                                .foregroundColor(.white)
                            
                            VStack(alignment: .leading, spacing: 6) {
                                ForEach(langs, id: \.iso6391) { lang in
                                    HStack {
                                        Circle()
                                            .fill(Color.green)
                                            .frame(width: 8, height: 8)
                                        Text(lang.englishName ?? lang.name ?? "Desconocido")
                                            .foregroundColor(.white.opacity(0.9))
                                        Spacer()
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    }
                    
                    // Boton de favoritos
                    Button(action: {
                        if let movie = movie {
                            Task {
                                do {
                                    let response = try await api.addFavorite(
                                        itemId: movie.id,
                                        type: "movie",
                                        title: movie.title
                                    )
                                    alertMessage = response.message
                                    showAlert = true
                                } catch {
                                    print("Error al agregar favorito:", error)
                                    alertMessage = "No se pudo agregar a favoritos"
                                    showAlert = true
                                }
                            }
                        }
                    }) {
                        HStack {
                            Image(systemName: "heart.fill")
                            Text("Agregar a favoritos")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding(.horizontal)
                    }
                    .alert("Favoritos", isPresented: $showAlert) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        Text(alertMessage)
                    }
                    .padding(.top, 10)
                    
                    Spacer(minLength: 40)
                }
                .padding(.top, 80)
            }
            
            // Boton de regreso
            VStack {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    Spacer()
                }
                .padding(.top, 20)
                .padding(.leading, 16)
                Spacer()
            }
            
            if isLoading {
                ProgressView("Cargando...")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(12)
            }
            
            if showError {
                VStack {
                    Text("Error al cargar detalles.")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red.opacity(0.7))
                        .cornerRadius(12)
                    
                    Button("Reintentar") {
                        loadMovie()
                    }
                    .padding(.top)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
             animate = true
             loadMovie()
        }
    }

    // Informacion de filas
    private func infoRow(_ title: String, _ value: String?) -> some View {
        HStack {
            Text(title + ":")
                .foregroundColor(.white.opacity(0.7))
                .frame(width: 120, alignment: .leading)
            Spacer()
            Text(value ?? "-")
                .foregroundColor(.white)
                .multilineTextAlignment(.trailing)
        }
    }

    // Carga de datos
    private func loadMovie() {
        Task {
            isLoading = true
            do {
                let detail = try await api.getMovieDetail(id: id)
                self.movie = detail
                self.isLoading = false
                self.showError = false
            } catch {
                print("ERROR:", error)
                isLoading = false
                showError = true
            }
        }
    }
}
