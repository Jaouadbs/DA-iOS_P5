//
//  AuthenticationViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation

class AuthenticationViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    private let authenticationRepository: AuthenticationRepository
    private let onLoginSuccess : () -> Void

    init(authenticationRepository: AuthenticationRepository = AuthenticationRepository(), onLoginsuccess: @escaping () -> Void) {
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

    }

    /// verifier si l'email est valide
    private func isEmailValid(_ username: String) -> Bool {
        let usernameRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", usernameRegex)
        return emailPredicate.evaluate(with: username)
    }

}
