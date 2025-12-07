//
//  SeriesView.swift
//  EntertainmentApp
//
//  Created by Hulda Daniela Crisanto Luna on 27/11/25.
//

import SwiftUI

struct SeriesView: View {
    @State private var series: [Serie] = []
    @State private var loading = true
    @State private var errorMessage: String?
    @State private var searchText = ""
    @StateObject private var nav = NavigationManager.shared

    var body: some View {
        NavigationStack {
            VStack {
                SearchBarView(text: $searchText)
                    .padding(.bottom, 5)

                Group {
                    if loading {
                        ProgressView("Cargando series...")
                    }
                    else if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                    else {
                        List(series) { serie in
                            Button {
                                nav.pushSeriesDetail(id: serie.id)
                            } label: {
                            // NavigationLink(destination: SeriesDetailView(id: serie.id)) {
                                HStack {
                                    PosterView(url: serie.poster)
                                        .frame(width: 60, height: 90)

                                    VStack(alignment: .leading) {
                                        Text(serie.name)
                                            .font(.headline)

                                        Text(serie.overview)
                                            .font(.caption)
                                            .lineLimit(3)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Series")
            .onAppear {
                loadPopularSeries()
            }
            .onChange(of: searchText) { newValue in
                Task {
                    if newValue.isEmpty {
                        loadPopularSeries()
                    } else {
                        await searchSeries()
                    }
                }
            }
            .navigationDestination(item: $nav.seriesDetailID) { id in
                SeriesDetailView(id: id)
            }
        }
    }

    func searchSeries() async {
        do {
            let results = try await ApiService().searchSerie(query: searchText)
            await MainActor.run { self.series = results }
        } catch {
            print("Error de búsqueda:", error)
        }
    }
    
    func loadPopularSeries() {
        guard let url = URL(string: "http://127.0.0.1:8000/api/tmdb/series/popular") else {
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
                        let decodedSeries = try JSONDecoder().decode([Serie].self, from: data)
                        self.series = decodedSeries
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
    SeriesView()
}
