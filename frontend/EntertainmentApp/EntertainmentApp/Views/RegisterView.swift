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
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var last_name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage: String?
    @State private var isLoading = false
    
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
                .textContentType(.emailAddress)
                .textInputAutocapitalization(.never)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            
            SecureField("Contraseña", text: $password)
                .textContentType(.newPassword)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)

            SecureField("Confirmar contraseña", text: $confirmPassword)
                .textContentType(.newPassword)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            
            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
                    .bold()
            }
            
            Button(action: registro) {
                if isLoading {
                    ProgressView().tint(.white)
                } else {
                    Text("Registrarse")
                }
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
        
        isLoading = true
        errorMessage = nil
        
        api.register(name: name,last_name: last_name, email: email, password: password) { success, error in
            DispatchQueue.main.async {
                isLoading = false
                if success {
                    dismiss()
                } else {
                    errorMessage = error
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        RegisterView()
            .environmentObject(AppState())
            .environmentObject(ApiService())
    }
}
