//
//  LoginView.swift
//  EntertainmentApp
//
//  Created by Hulda Daniela Crisanto Luna on 24/11/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var api: ApiService
    
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    
    @Environment(\.dismiss) private var dismiss
    @State private var isLoading = false
    
    var body: some View {
        VStack{
            Text("Iniciar Sesión")
                .font(.largeTitle)
                .bold()
            
            TextField("Correo electrónico", text: $email)
                .textInputAutocapitalization(.never)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            
            SecureField("Contraseña", text: $password)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            
            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
                    .bold()
            }
            
            Button(action: login) {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Ingresar")
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.teal)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            NavigationLink("¿No tienes cuenta? Regístrate", destination: RegisterView())
                .padding(.top)
        }
        .padding()
    }
    
    func login() {
        isLoading = true
        errorMessage = nil
        
        api.login(email: email, password: password) { success, error in
            DispatchQueue.main.async {
                isLoading = false
                if success {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation {
                            appState.isLoggedIn = true
                        }
                    }
                } else {
                    errorMessage = error
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        LoginView()
            .environmentObject(AppState())
            .environmentObject(ApiService())
    }
}
