//
//  AuthenticationViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation

class AuthenticationViewModel: ObservableObject {

    // Inputs
    @Published var username: String = ""
    @Published var password: String = ""

    // Outputs
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    //Dépendance abstraite
    private let authenticationRepository: AuthenticationRepositoryType

    // Callback appelé après login réussi
    private let onLoginSuccess : () -> Void

    var isFormValid: Bool {
        isEmailValid(username) && !password.isEmpty
    }

    init(authenticationRepository: AuthenticationRepositoryType = AuthenticationRepository(),
        onLoginsuccess: @escaping () -> Void
    ) {
        self.authenticationRepository = authenticationRepository
        self.onLoginSuccess = onLoginsuccess
    }
    
    
    // Méthode appelée quand l'utilisateur clique sur se connecter
    func login() {
        // Réinitialisation de l'erreur
        errorMessage = nil
        
        // validation des champs avant l'appel de l'API
        guard isEmailValid(username) else {
            errorMessage = "Adresse email invalide"
            return
        }
        guard !password.isEmpty else {
            errorMessage = "Le mot de passe est obligatoire"
            return
        }
        
        // Appel API
        isLoading = true
        // pour le suivi de la tentative la connexion
        print("Tentative de connexion avec : \(username )")
        
        Task {
            do {
                // appel de repository pour se connecter
                let token = try await authenticationRepository.login(username: username, password: password)
                
                print("Token reçu: \(token)")
                
                // Mise à jour sur le thread principal pour modifier l'UI
                await MainActor.run {
                    //Sauvegarder le token
                    AuthenticationToken.shared.token = token
                    self.isLoading = false
                    // Appele la fonction de connexion réussite
                    self.onLoginSuccess()
                }
            } catch {
                print("Erreur login :\(error)")
                
                await MainActor.run{
                    self.errorMessage = "Indentifiant inncorrect ou problème de connexion"
                    self.isLoading = false
                }
            }
        }
        
    }
    
    /// verifier si l'email est valide
    private func isEmailValid(_ username: String) -> Bool {
        let usernameRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", usernameRegex)
        return emailPredicate.evaluate(with: username)
    }
    
}

