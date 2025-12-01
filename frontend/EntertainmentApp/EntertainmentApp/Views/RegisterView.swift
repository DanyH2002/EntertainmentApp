//
//  RegisterView.swift
//  EntertainmentApp
//
//  Created by Hulda Daniela Crisanto Luna on 24/11/25.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var api: ApiService
    
    @State private var name = ""
    @State private var last_name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage: String?
    
    var body: some View {
        VStack (spacing: 25){
            Text("Registro")
                .font(.largeTitle)
                .bold()
            
            TextField("Nombre", text: $name)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            
            TextField("Apellido", text: $last_name)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            
            TextField("Correo electrónico", text: $email)
                .textInputAutocapitalization(.never)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            
            SecureField("Contraseña", text: $password)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            
            SecureField("Confirmar contraseña", text: $confirmPassword)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            
            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
                    .bold()
            }
            
            Button("Registrarse") {
                registro()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
    
    func registro(){
        guard password == confirmPassword else {
            errorMessage = "Las contraseñas no coinciden"
            return
        }
        api.register(name: name,last_name: last_name, email: email, password: password) { success, error in
            if success {
                appState.isLoggedIn = true
            } else {
                errorMessage = error
            }
        }
    }
}

#Preview {
    RegisterView()
}
