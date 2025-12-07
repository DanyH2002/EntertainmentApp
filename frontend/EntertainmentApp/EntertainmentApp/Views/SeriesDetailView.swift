//
//  SeriesDetailView.swift
//  EntertainmentApp
//
//  Created by Hulda Daniela Crisanto Luna on 03/12/25.
//

import SwiftUI

struct SeriesDetailView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var api: ApiService
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    let id: Int
    
    @State private var series: SeriesDetail?
    @State private var isLoading = true
    @State private var showError = false
    @State private var animate = false
    
    var body: some View {
        ZStack {
            if let backdrop = series?.backdropPath,
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
                    Text(series?.name ?? "Cargando...")
                        .font(.largeTitle.bold())
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding(.top, 8)
                    
                    if let rating = series?.voteAverage {
                        Text("⭐️ \(String(format: "%.1f", rating))/10")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Sinopsis")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                        
                        Text(series?.overview ?? "No hay descripción disponible.")
                            .foregroundColor(.white.opacity(0.95))
                            .font(.body)
                            .lineSpacing(6)
                            .multilineTextAlignment(.leading)
                            .padding(.top, 4)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    if let genres = series?.genres, !genres.isEmpty {
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
                    
                    if series != nil {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Información")
                                .font(.title3.bold())
                                .foregroundColor(.white)
                            
                            VStack(spacing: 8) {
                                infoRow("Fecha de estreno", series?.firstAirDate)
                                infoRow("Estado", series?.status)
                                infoRow("Idioma original", series?.originalLanguage?.uppercased())
                                infoRow("Temporadas", series?.numberOfSeasons != nil ? "\(series!.numberOfSeasons!)" : nil)
                                infoRow("Episodios", series?.numberOfEpisodes != nil ? "\(series!.numberOfEpisodes!)" : nil)
                                
                                if let homepage = series?.homepage {
                                    infoRow("Página oficial", homepage.isEmpty ? "-" : homepage)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    }
                    
                    if let langs = series?.spokenLanguages, !langs.isEmpty {
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
                    Button(action: {
                        if let series = series {
                            Task {
                                do {
                                    let response = try await api.addFavorite(
                                        itemId: series.id,
                                        type: "serie",
                                        title: series.name
                                    )
                                    alertMessage = response.message
                                    showAlert = true
                                } catch {
                                    print("Error al agregar favorito:", error)
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
                        .background(Color.purple)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding(.horizontal)
                    }.alert("Favoritos", isPresented: $showAlert) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        Text(alertMessage)
                    }
                    .padding(.top, 10)
                    
                    Spacer(minLength: 40)
                }
                .padding(.top, 80)
            }
            
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
                        loadSeries()
                    }
                    .padding(.top)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            animate = true
            loadSeries()
        }
    }
    
    private func infoRow(_ title: String, _ value: String?) -> some View {
        HStack {
            Text(title + ":")
                .foregroundColor(.white.opacity(0.7))
                .frame(width: 140, alignment: .leading)
            Spacer()
            Text(value ?? "-")
                .foregroundColor(.white)
                .multilineTextAlignment(.trailing)
        }
    }
    
    // Cargar detalles
    private func loadSeries() {
        Task {
            isLoading = true
            do {
                let detail = try await api.getSeriesDetail(id: id)
                self.series = detail
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
