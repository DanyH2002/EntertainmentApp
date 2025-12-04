//
//  ApiService.swift
//  EntertainmentApp
//
//  Created by Hulda Daniela Crisanto Luna on 24/11/25.
//

import Foundation
import Combine

class ApiService: ObservableObject {
    private let baseUrl = "http://127.0.0.1:8000/api"
    
    // Token 
    @Published var token: String? {
        didSet {
            DispatchQueue.main.async {
                UserDefaults.standard.set(self.token, forKey: "token")
            }
        }
    }
        
    init() {
        // Cargar token guardado
        self.token = UserDefaults.standard.string(forKey: "token")
    }
    
    // Funcion para peticiones
    func sendRequest(url: URL, method: String,body: [String: Any]?,
                             completion: @escaping ([String: Any]?, String?) -> Void){ // Devuelve respuesta
        print("📡 [sendRequest-closure] Enviando petición a: \(url.absoluteString)")
        if let body = body { print("➡️ Body: \(body)") }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // Si hay un token agrega a los headers
        if let token = token {
            print("🔑 Token enviado")
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        // Se asegura que el body que se envia sea un JSON
        if let body = body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        // Envio de peticion asincrona
        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ [sendRequest-closure] Error de conexión:", error.localizedDescription)
                    completion(nil, error.localizedDescription)
                    return
                }
                guard let data = data else {
                    print("❌ [sendRequest-closure] Sin datos del servidor")
                    completion(nil, "Sin datos del servidor")
                    return
                }
                // Parcea la respuesta a JSON
                print("📥 [sendRequest-closure] JSON bruto recibido:")
                print(String(data: data, encoding: .utf8) ?? "⚠️ No se pudo convertir a String")
                let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
                completion(json, nil)
            }
        }
        .resume() // Inicia la peticion, sino no se ejecuta
    }
    
    // Funcion auxiliar que recibe un codeable y lo decodifique
    func sendRequest<T: Decodable>(url: URL, method: String,
                                   body: [String: Any]? = nil, returnType: T.Type) async throws -> T {
        print("📡 [sendRequest-async] Enviando petición a: \(url.absoluteString)")
        if let body = body { print("➡️ Body: \(body)") }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Token si existe
        if let token = token {
            print("🔑 Token enviado en headers")
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Body si aplica
        if let body = body {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        }
        
        // Ejecutar petición
        let (data, response) = try await URLSession.shared.data(for: request)
        print("📥 [sendRequest-async] DATA recibido (RAW):")
        print(String(data: data, encoding: .utf8) ?? "⚠️ No se pudo convertir a String")
        
        if let http = response as? HTTPURLResponse {
               print("📬 Status code recibido: \(http.statusCode)")
        }
        
        // Decodificar JSON → Modelo
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let decoded = try decoder.decode(T.self, from: data)
            print("✅ [sendRequest-async] JSON decodificado correctamente")
            return decoded
        } catch {
            print("❌ [sendRequest-async] ERROR al decodificar JSON:")
            print(error)
            throw error
        }
        //return try decoder.decode(T.self, from: data)
    }
    
    // Funcion login
    func login(email: String, password: String,
               completion: @escaping (Bool, String?) -> Void) { // Devuelve resultados asincronos
        guard let url = URL(string: "\(baseUrl)/login") else { return }
        let body: [String: Any] = [ // Construccion del JSON
            "email": email,
            "password": password
        ]
        sendRequest(url: url, method: "POST", body: body) { json, error in
            DispatchQueue.main.async {
                // Devuelve el error (si hay)
                if let error = error {
                    completion(false, error)
                    return
                }
                // Guarda el token
                guard let token = json?["token"] as? String else {
                    completion(false, "Token inválido")
                    return
                }
                self.token = token
                completion(true, nil)
            }
        }
    }
    
    // Funcion de registro
    func register(name: String, last_name:String, email: String, password: String,
                  completion: @escaping (Bool, String?) -> Void) {
        guard let url = URL(string: "\(baseUrl)/register") else { return }
        let body: [String: Any] = [
            "name": name,
            "last_name": last_name,
            "email": email,
            "password": password
        ]
        sendRequest(url: url, method: "POST", body: body) { json, error in
            if let error = error {
                DispatchQueue.main.async { completion(false, error) }
                return
            }
                        
            guard let token = json?["token"] as? String else {
                DispatchQueue.main.async {
                    completion(false, "Token inválido")
                }
                return
            }
                        
            DispatchQueue.main.async {
                self.token = token
                completion(true, nil)
            }
        }
    }
    
    // Funcion para Favoritos
    func addFavorite(itemId: Int, type: String, title: String) async throws {
        guard let url = URL(string: "\(baseUrl)/favorite/add") else { throw URLError(.badURL) }
        let body: [String: Any] = [
            "item_id": itemId,
            "type": type,
            "title": title
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
    }
    
    // ver detalles de las peliculas
    func getMovieDetail(id: Int) async throws -> MovieDetail {
        let url = URL(string: "\(baseUrl)/tmdb/movie/\(id)")!
        print("📡 [getMovieDetail] Ejecutando petición a: \(url.absoluteString)")
        
        let detail: MovieDetail = try await sendRequest(
            url: url,
            method: "GET",
            body: nil,
            returnType: MovieDetail.self
        )
        
        print("✅ [getMovieDetail] Respuesta decodificada: \(detail)")
        
        return detail
    }
    
    // ver detalles de las series
    func getSeriesDetail(id: Int) async throws -> SeriesDetail {
        let url = URL(string: "\(baseUrl)/tmdb/series/\(id)")!
        
        print("📡 [getSeriesDetail] Ejecutando petición a: \(url.absoluteString)")
        
        let detail: SeriesDetail = try await sendRequest(
            url: url,
            method: "GET",
            body: nil,
            returnType: SeriesDetail.self
        )
        
        print("✅ [getSeriesDetail] Respuesta decodificada: \(detail)")
        
        return detail
    }
    
    // hacer busquedas
    func searchMovie(query: String) async throws -> [Movie] {
        guard let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseUrl)/tmdb/search/movie?q=\(encoded)") else {
            return []
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)

        // Debug para ver EXACTO qué responde Laravel
        print("📄 RAW RESPONSE:", String(data: data, encoding: .utf8) ?? "no readable")

        let decoded = try JSONDecoder().decode(SearchMovieResponse.self, from: data)
        return decoded.results
    }

    func searchSerie(query: String) async throws -> [Serie] {
        guard let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseUrl)/tmdb/search/serie?q=\(encoded)") else {
            return []
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)

        print("📄 RAW RESPONSE:", String(data: data, encoding: .utf8) ?? "no readable")

        let decoded = try JSONDecoder().decode(SearchSeriesResponse.self, from: data)
        return decoded.results
    }
    
}
