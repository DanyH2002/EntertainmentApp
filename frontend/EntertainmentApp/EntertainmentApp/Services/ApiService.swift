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
    
    // Token persistente + observable
    @Published var token: String? {
        didSet {
            UserDefaults.standard.set(token, forKey: "token")
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
         print("➡️ Método: \(method)")
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
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ [sendRequest-closure] Error de conexión:", error.localizedDescription)
                completion(nil, "Error en la conexión")
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
        .resume() // Inicia la peticion, sino no se ejecuta
    }
    
    // Funcion auxiliar que recibe un codeable y lo decodifique
    func sendRequest<T: Decodable>(url: URL, method: String,
                                   body: [String: Any]? = nil, returnType: T.Type) async throws -> T {
        print("📡 [sendRequest-async] Enviando petición a: \(url.absoluteString)")
            print("➡️ Método: \(method)")
            if let body = body { print("➡️ Body: \(body)") }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Token si existe
        if let token = token {
            print("🔑 Token enviado en headers")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Body si aplica
        if let body = body {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        // Ejecutar petición
        let (data, response) = try await URLSession.shared.data(for: request)
        print("📥 [sendRequest-async] DATA recibido (RAW):")
        print(String(data: data, encoding: .utf8) ?? "⚠️ No se pudo convertir a String")
        
        if let http = response as? HTTPURLResponse {
               print("📬 Status code recibido: \(http.statusCode)")
        }
        
        // Validar status code
        guard let http = response as? HTTPURLResponse,
              (200...299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
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
                completion(false, error)
                print(error)
                return
            }
            guard let token = json?["token"] as? String else {
                completion(false, "Token inválido")
                return
            }
            self.token = token
            completion(true, nil)
        }
    }
    
    // Funcion para Favoritos
    func addFavorite(itemId: Int, type: String, title: String) async throws {
        guard let url = URL(string: "\(baseUrl)/favorite/add") else {
            throw URLError(.badURL)
        }
        let body: [String: Any] = [
            "item_id": itemId,
            "type": type,
            "title": title
        ]
        var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
    }
    
    // ver detalles de las peliculas
    func getMovieDetail(id: Int) async throws -> MovieDetail {
        let url = URL(string: "http://127.0.0.1:8000/api/tmdb/movie/\(id)")!
        
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
}
